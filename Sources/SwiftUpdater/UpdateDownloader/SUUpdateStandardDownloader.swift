import Foundation

/// An object that downloads updates.
public struct SUUpdateStandardDownloader: SUUpdateDownloader {
    /// The `URLSession` for the download.
    public let urlSession: URLSession

    /// Creates a downloader that downloads updates using the specified `URLSession`.
    ///
    /// - Parameter urlSession: The `URLSession` for the download. The default is `shared`.
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    /// Downloads an update from the specified remote URL.
    ///
    /// - Parameters:
    ///   - url: The remote URL.
    ///   - onProgress: A closure to run when the progress changes.
    /// - Returns: The local file URL of the downloaded update.
    public func download(
        from url: URL,
        onProgress: @escaping @MainActor (SUProgress?) -> Void
    ) async throws -> URL {
        let download = Download(
            url: url,
            urlSession: urlSession,
            onProgress: onProgress
        )

        return try await download.start()
    }
}

public extension SUUpdateDownloader where Self == SUUpdateStandardDownloader {
    /// Creates a downloader that downloads updates using the specified `URLSession`.
    ///
    /// - Parameter urlSession: The `URLSession` for the download. The default is `shared`.
    static func standard(urlSession: URLSession = .shared) -> SUUpdateStandardDownloader {
        SUUpdateStandardDownloader(urlSession: urlSession)
    }
}

private final class Download: NSObject, URLSessionDownloadDelegate {
    private let url: URL
    private let urlSession: URLSession
    private let onProgress: @MainActor (SUProgress?) -> Void

    @MainActor private var continuation: CheckedContinuation<URL, Swift.Error>?

    init(
        url: URL,
        urlSession: URLSession,
        onProgress: @escaping @MainActor (SUProgress?) -> Void
    ) {
        self.url = url
        self.urlSession = urlSession
        self.onProgress = onProgress
    }

    @MainActor
    func start() async throws -> URL {
        try await withCheckedThrowingContinuation { continuation in
            guard self.continuation == nil else {
                continuation.resume(throwing: Error.downloadAlreadyStarted)
                return
            }

            self.continuation = continuation

            let request = URLRequest(url: url)
            let task = urlSession.downloadTask(with: request)
            task.delegate = self
            task.resume()
        }
    }

    func urlSession(
        _: URLSession,
        downloadTask: URLSessionDownloadTask, // swiftlint:disable:this unused_parameter
        didWriteData bytesWritten: Int64, // swiftlint:disable:this unused_parameter
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64
    ) {
        Task { @MainActor in
            onProgress(
                .bytes(
                    completed: totalBytesWritten,
                    total: totalBytesExpectedToWrite
                )
            )
        }
    }

    func urlSession(
        _: URLSession,
        downloadTask: URLSessionDownloadTask, // swiftlint:disable:this unused_parameter
        didFinishDownloadingTo location: URL
    ) {
        let destination = location
            .deletingLastPathComponent()
            .appending(component: UUID().uuidString)
            .appendingPathExtension("tmp")

        do {
            try FileManager.default.moveItem(
                at: location,
                to: destination
            )

            try? FileManager.default.removeItem(at: location)

            Task { @MainActor in
                continuation?.resume(returning: destination)
                continuation = nil
            }
        } catch {
            Task { @MainActor in
                continuation?.resume(throwing: error)
                continuation = nil
            }
        }
    }

    func urlSession(
        _: URLSession,
        task: URLSessionTask, // swiftlint:disable:this unused_parameter
        didCompleteWithError error: Swift.Error?
    ) {
        Task { @MainActor in
            continuation?.resume(throwing: error ?? Error.downloadFailed)
            continuation = nil
        }
    }

    enum Error: Swift.Error {
        case downloadAlreadyStarted
        case downloadFailed
    }
}
