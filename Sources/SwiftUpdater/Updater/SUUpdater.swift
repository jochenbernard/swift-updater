import Foundation

/// An object that manages updates.
public final class SUUpdater: Sendable {
    public let bundle: Bundle
    public let downloader: SUUpdateDownloader
    public let extractor: SUUpdateExtractor?

    /// Creates an updater for the specified bundle using the specified downloader and extractor.
    ///
    /// - Parameters:
    ///   - bundle: The bundle. The default is `main`.
    ///   - downloader: The downloader. The default is ``SUUpdateDownloader/standard(urlSession:)``.
    ///   - extractor: The extractor. The default is `nil`.
    public init(
        bundle: Bundle = .main,
        downloader: SUUpdateDownloader = .standard(),
        extractor: SUUpdateExtractor? = nil
    ) {
        self.bundle = bundle
        self.downloader = downloader
        self.extractor = extractor
    }

    /// Creates an update from the specified remote url.
    ///
    /// - Parameter updateURL: The remote URL.
    ///
    /// This update still has to be started using the ``SUUpdate/start()`` method.
    @MainActor
    public func update(from updateURL: URL) -> SUUpdate {
        SUUpdate(
            url: updateURL,
            bundle: bundle,
            downloader: downloader,
            extractor: extractor
        )
    }
}
