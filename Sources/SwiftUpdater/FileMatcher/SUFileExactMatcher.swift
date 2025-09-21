/// An object that matches files by their name and extension.
public struct SUFileExactMatcher: SUFileMatcher {
    /// The file name and extension required to match.
    public let file: String

    /// Creates a matcher that matches files by their name and extension.
    ///
    /// - Parameter file: The file name and extension required to match.
    public init(_ file: String) {
        self.file = file
    }

    /// Returns a boolean value that indicates whether a file's name and extension match.
    ///
    /// - Parameter file: The file.
    /// - Returns: `true` if the file's name and extension match, `false` if they do not.
    public func matches(_ file: String) -> Bool {
        file == self.file
    }
}

public extension SUFileMatcher where Self == SUFileExactMatcher {
    /// Creates a matcher that matches files by their name and extension.
    ///
    /// - Parameter file: The file name and extension required to match.
    static func exact(_ file: String) -> SUFileExactMatcher {
        SUFileExactMatcher(file)
    }
}
