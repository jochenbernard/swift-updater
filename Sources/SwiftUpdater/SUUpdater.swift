import AppKit

public struct SUUpdater {
    private init() {}

    public static func installUpdate(from updateURL: URL) async throws {
        let bundleURL = Bundle.main.bundleURL
        try FileManager.default.removeItem(at: bundleURL)
        try FileManager.default.moveItem(
            at: updateURL,
            to: bundleURL
        )
        try await NSWorkspace.shared.openApplication(
            at: bundleURL,
            configuration: NSWorkspace.OpenConfiguration()
        )
        await NSApplication.shared.terminate(self)
    }
}
