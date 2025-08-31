import Foundation

public extension Bundle {
    /// The semantic version of the bundle.
    ///
    /// This version is derived from the `CFBundleShortVersionString` in the bundle's `Info.plist`. This value is `nil`
    /// if the bundle does not contain an `Info.plist` or the `CFBundleShortVersionString` does not contain a valid
    /// semantic version.
    var version: SUVersion? {
        guard let string = infoDictionary?["CFBundleShortVersionString"] as? String else {
            return nil
        }

        return SUVersion(string: string)
    }
}
