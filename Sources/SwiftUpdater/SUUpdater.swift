import AppKit

/// A collection of functions to update the app bundle.
public struct SUUpdater {
    private init() {}

    /// Installs an update from a local app bundle.
    ///
    /// - Parameter updateURL: The URL of the local app bundle.
    public static func installUpdate(from updateURL: URL) throws {
        let bundleURL = Bundle.main.bundleURL
        try FileManager.default.removeItem(at: bundleURL)
        try FileManager.default.moveItem(
            at: updateURL,
            to: bundleURL
        )
    }

    /// Relaunches the app.
    @MainActor
    public static func relaunch() {
        let bundleURL = Bundle.main.bundleURL
        NSWorkspace.shared.openApplication(
            at: bundleURL,
            configuration: NSWorkspace.OpenConfiguration()
        )
        NSApplication.shared.terminate(self)
    }
}
