import AppKit

/// An object that manages updates for a certain bundle.
public final class SUUpdater: Sendable {
    public let bundle: Bundle

    /// Creates an updater for the specified bundle.
    ///
    /// - Parameter bundle: The bundle.
    public init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    /// Installs an update from a local bundle.
    ///
    /// - Parameter updateURL: The URL of the local bundle.
    public func install(from updateURL: URL) throws {
        let bundleURL = bundle.bundleURL
        try FileManager.default.removeItem(at: bundleURL)
        try FileManager.default.moveItem(
            at: updateURL,
            to: bundleURL
        )
    }

    /// Launches the bundle.
    public func launch() {
        NSWorkspace.shared.openApplication(
            at: bundle.bundleURL,
            configuration: NSWorkspace.OpenConfiguration()
        )
    }

    /// Relaunches the bundle.
    ///
    /// This function will throw ``Error/cannotRelaunchBundle`` if the updater does not manage the bundle that contains
    /// the current executable.
    @MainActor
    public func relaunch() throws(Error) {
        guard bundle == .main else {
            throw Error.cannotRelaunchBundle
        }

        launch()
        NSApplication.shared.terminate(self)
    }

    /// An error thrown by an ``SUUpdater``.
    public enum Error: Swift.Error {
        /// The updater cannot relaunch the bundle.
        ///
        /// This error is thrown whenever ``SUUpdater/relaunch()`` is called on an ``SUUpdater`` which does not manage
        /// the bundle that contains the current executable.
        case cannotRelaunchBundle
    }
}
