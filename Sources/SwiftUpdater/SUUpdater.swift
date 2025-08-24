import AppKit

public struct SUUpdater {
    private init() {}

    public static func installUpdate(from updateURL: URL) throws {
        let bundleURL = Bundle.main.bundleURL
        try FileManager.default.removeItem(at: bundleURL)
        try FileManager.default.moveItem(
            at: updateURL,
            to: bundleURL
        )
    }

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
