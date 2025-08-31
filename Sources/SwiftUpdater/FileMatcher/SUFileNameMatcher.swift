/// An object which matches files by their name.
public struct SUFileNameMatcher: SUFileMatcher {
    /// The file name required to match.
    public let fileName: String

    /// Creates a matcher which matches files by their name.
    ///
    /// - Parameter fileName: The file name required to match.
    public init(_ fileName: String) {
        self.fileName = fileName
    }

    /// Returns a boolean value that indicates whether a file's name matches.
    ///
    /// - Parameter file: The file.
    /// - Returns: `true` if the file's name matches, `false` if it does not.
    public func matches(_ file: String) -> Bool {
        let lastDotIndex = file.lastIndex(of: ".") ?? file.endIndex
        let fileName = file.prefix(upTo: lastDotIndex)
        return fileName == self.fileName
    }
}

public extension SUFileMatcher where Self == SUFileNameMatcher {
    /// Creates a matcher which matches files by their name.
    ///
    /// - Parameter fileName: The file name required to match.
    static func fileName(_ fileName: String) -> SUFileNameMatcher {
        SUFileNameMatcher(fileName)
    }
}
