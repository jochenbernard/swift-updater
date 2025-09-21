import AppKit

/// An object that represents an ongoing update.
@Observable
@MainActor
public final class SUUpdate {
    /// The remote URL of the update.
    public let url: URL

    private let bundle: Bundle
    private let downloader: SUUpdateDownloader
    private let extractor: SUUpdateExtractor?

    /// The current state of the update.
    public private(set) var state: State

    init(
        url: URL,
        bundle: Bundle,
        downloader: SUUpdateDownloader,
        extractor: SUUpdateExtractor?
    ) {
        self.url = url

        self.bundle = bundle
        self.downloader = downloader
        self.extractor = extractor

        self.state = .waiting
    }

    /// Cancels the update.
    ///
    /// - Throws: This method will throw ``Error/unableToCancelUpdate`` if the update is unable to be canceled.
    public func cancel() throws(Error) {
        switch state {
        case .waiting, .downloading, .extracting:
            state = .canceled

        case .applying, .relaunching, .completed, .failed, .canceled:
            throw Error.unableToCancelUpdate
        }
    }

    /// Starts the update.
    ///
    /// - Throws: This method will throw ``Error/updateAlreadyStarted`` if the update was already started.
    public func start() throws(Error) {
        guard case .waiting = state else {
            throw Error.updateAlreadyStarted
        }

        state = .downloading(progress: nil)

        Task {
            do {
                try await start()
            } catch {
                state = .failed(error: error)
            }
        }
    }

    private func start() async throws {
        if case .canceled = state {
            return
        }

        let downloadURL = try await download()

        if case .canceled = state {
            return
        }

        let updateURL = try await extract(from: downloadURL)

        if case .canceled = state {
            return
        }

        try apply(from: updateURL)

        relaunch()

        state = .completed
    }

    private func download() async throws -> URL {
        state = .downloading(progress: nil)

        return try await downloader.download(
            from: url,
            onProgress: { progress in
                guard case .downloading = self.state else {
                    return
                }

                self.state = .downloading(progress: progress)
            }
        )
    }

    private func extract(from downloadURL: URL) async throws -> URL {
        guard let extractor else {
            return downloadURL
        }

        state = .extracting(progress: nil)

        return try await extractor.extract(
            from: downloadURL,
            onProgress: { progress in
                guard case .extracting = self.state else {
                    return
                }

                self.state = .downloading(progress: progress)
            }
        )
    }

    private func apply(from updateURL: URL) throws {
        state = .applying

        let bundleURL = bundle.bundleURL
        try FileManager.default.removeItem(at: bundleURL)
        try FileManager.default.moveItem(
            at: updateURL,
            to: bundleURL
        )
    }

    private func relaunch() {
        guard bundle == .main else {
            return
        }

        state = .relaunching

        NSWorkspace.shared.openApplication(
            at: bundle.bundleURL,
            configuration: NSWorkspace.OpenConfiguration()
        )
        NSApplication.shared.terminate(self)
    }

    /// Constants for determining the current state of an update.
    public enum State {
        /// The update is waiting to be started.
        case waiting

        /// The update is being downloaded.
        case downloading(progress: SUProgress?)

        /// The update is being extracted.
        case extracting(progress: SUProgress?)

        /// The update is being applied.
        case applying

        /// The bundle is being relaunched.
        case relaunching

        /// The udpate has completed.
        case completed

        /// The update has failed.
        case failed(error: Swift.Error)

        /// The update was canceled.
        case canceled
    }

    /// An error thrown by an ``SUUpdate``.
    public enum Error: Swift.Error {
        /// The update was already started.
        case updateAlreadyStarted

        /// The update was unable to be canceled.
        case unableToCancelUpdate
    }
}
