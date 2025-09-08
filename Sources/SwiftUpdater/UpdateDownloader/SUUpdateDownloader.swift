import Foundation

/// An object which downloads updates.
public protocol SUUpdateDownloader: Sendable {
    /// Downloads an update from a URL.
    ///
    /// - Parameters:
    ///   - url: The URL.
    ///   - onProgress: A closure to run when the progress changes.
    /// - Returns: The local file URL of the downloaded update.
    func download(
        from url: URL,
        onProgress: @escaping @Sendable (_ progress: SUProgress?) -> Void
    ) async throws -> URL
}
