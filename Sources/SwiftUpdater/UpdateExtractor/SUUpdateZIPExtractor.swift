import Foundation

/// An object which extracts updates from a ZIP archive.
public struct SUUpdateZIPExtractor: SUUpdateExtractor {
    /// The file matcher to determine which file in the archive should be extracted.
    public let fileMatcher: SUFileMatcher

    /// Creates an extractor which extracts updates from a ZIP archive.
    ///
    /// - Parameter fileMatcher: The file matcher to determine which file in the archive should be extracted.
    public init(fileMatcher: SUFileMatcher) {
        self.fileMatcher = fileMatcher
    }

    /// Extracts an update from a local ZIP archive.
    ///
    /// - Parameter url: The local ZIP archive.
    /// - Returns: The local file URL of the extracted update.
    public func extract(from url: URL) throws -> URL {
        let destinationURL = url.deletingPathExtension()

        let process = Process()
        process.executableURL = URL(filePath: "/usr/bin/unzip")
        process.arguments = [
            url.path(percentEncoded: false),
            "-d",
            destinationURL.path(percentEncoded: false)
        ]

        try process.run()

        process.waitUntilExit()

        guard process.terminationStatus == .zero else {
            throw Error.failedToUnzip
        }

        let files = try FileManager
            .default
            .contentsOfDirectory(
                at: destinationURL,
                includingPropertiesForKeys: nil
            )
            .filter { file in
                fileMatcher.matches(file.lastPathComponent)
            }

        guard files.count <= 1 else {
            throw Error.moreThanOneMatchingFile
        }

        guard let file = files.first else {
            throw Error.noMatchingFiles
        }

        return file
    }

    /// An error thrown by an ``SUUpdateZIPExtractor``.
    public enum Error: Swift.Error {
        /// The ZIP archive failed to unzip.
        case failedToUnzip

        /// The ZIP archive did not contain any matching files.
        case noMatchingFiles

        /// The ZIP archive contained more than one matching file.
        case moreThanOneMatchingFile
    }
}

public extension SUUpdateExtractor where Self == SUUpdateZIPExtractor {
    /// Creates an extractor which extracts updates from a ZIP archive.
    ///
    /// - Parameter fileMatcher: The file matcher to determine which file in the archive should be extracted.
    static func zip(fileMatcher: SUFileMatcher) -> SUUpdateZIPExtractor {
        SUUpdateZIPExtractor(fileMatcher: fileMatcher)
    }
}
