import Foundation

/// An object that downloads updates.
public protocol SUUpdateDownloader: Sendable {
    /// Downloads an update from the specified remote URL.
    ///
    /// - Parameters:
    ///   - url: The remote URL.
    ///   - onProgress: A closure to run when the progress changes.
    /// - Returns: The local file URL of the downloaded update.
    func download(
        from url: URL,
        onProgress: @escaping @Sendable @MainActor (_ progress: SUProgress?) -> Void
    ) async throws -> URL
}
