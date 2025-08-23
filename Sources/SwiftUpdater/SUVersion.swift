public struct SUVersion: Comparable, Sendable {
    public let major: Int
    public let minor: Int
    public let patch: Int

    public var string: String {
        versions
            .map(\.description)
            .joined(separator: ".")
    }

    private var versions: [Int] {
        [major, minor, patch]
    }

    public init(
        major: Int,
        minor: Int,
        patch: Int
    ) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }

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
