import Foundation

/// An object which matches files by their extension.
public struct SUFileExtensionMatcher: SUFileMatcher {
    /// The file extension required to match.
    public let fileExtension: String

    /// Creates a matcher which matches files by their extension.
    ///
    /// - Parameter fileExtension: The file extension required to match.
    public init(_ fileExtension: String) {
        self.fileExtension = fileExtension
    }

    /// Returns a boolean value that indicates whether a file's extension matches.
    ///
    /// - Parameter file: The file.
    /// - Returns: `true` if the file's extension matches, `false` if it does not.
    public func matches(_ file: String) -> Bool {
        file.hasSuffix(".\(fileExtension)")
    }
}

public extension SUFileMatcher where Self == SUFileExtensionMatcher {
    /// Creates a matcher which matches files by their extension.
    ///
    /// - Parameter fileExtension: The file extension required to match.
    static func fileExtension(_ fileExtension: String) -> SUFileExtensionMatcher {
        SUFileExtensionMatcher(fileExtension)
    }
}
