import Foundation

/// An object which extracts updates.
public protocol SUUpdateExtractor: Sendable {
    /// Extracts an update from a local file URL.
    ///
    /// - Parameters:
    ///   - url: The local file URL.
    ///   - onProgress: A closure to run when the progress changes.
    /// - Returns: The local file URL of the extracted update.
    func extract(
        from url: URL,
        onProgress: (_ progress: SUProgress?) -> Void
    ) async throws -> URL
}
