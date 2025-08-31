import Foundation

/// An object which extracts updates.
public protocol SUUpdateExtractor: Sendable {
    /// Extracts an update from a local file URL.
    ///
    /// - Parameter url: The local file URL.
    /// - Returns: The local file URL of the extracted update.
    func extract(from url: URL) async throws -> URL
}
