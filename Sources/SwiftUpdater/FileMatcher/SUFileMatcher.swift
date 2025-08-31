import Foundation

/// An object which matches files.
public protocol SUFileMatcher {
    /// Returns a boolean value that indicates whether a file matches.
    ///
    /// - Parameter file: The file.
    /// - Returns: `true` if the file matches, `false` if it does not.
    func matches(_ file: String) -> Bool
}
