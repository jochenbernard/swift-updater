import Foundation

/// A semantic version.
public struct SUVersion: Comparable, Sendable {
    /// The major version.
    public let major: Int

    /// The minor version.
    public let minor: Int

    /// The patch version.
    public let patch: Int

    /// The semantic version string.
    public var string: String {
        versions
            .map(\.description)
            .joined(separator: ".")
    }

    private var versions: [Int] {
        [major, minor, patch]
    }

    /// Initializes a semantic version.
    ///
    /// - Paramters:
    ///   - major: The major version.
    ///   - minor: The minor version.
    ///   - patch: The patch version.
    public init(
        major: Int,
        minor: Int,
        patch: Int
    ) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }

    /// Initializes a semantic version from a string.
    ///
    /// - Parameter string: The semantic version string.
    public init?(string: String) {
        let versionStrings = string.split(
            separator: ".",
            maxSplits: 3,
            omittingEmptySubsequences: false
        )

        guard versionStrings.count == 3 else {
            return nil
        }

        let versions = versionStrings.compactMap({ Int($0) })

        guard versions.count == 3 else {
            return nil
        }

        self.init(
            major: versions[0],
            minor: versions[1],
            patch: versions[2]
        )
    }

    public static func < (lhs: Self, rhs: Self) -> Bool {
        for version in zip(lhs.versions, rhs.versions) {
            if version.0 < version.1 {
                return true
            }
            if version.0 > version.1 {
                return false
            }
        }

        return false
    }
}
