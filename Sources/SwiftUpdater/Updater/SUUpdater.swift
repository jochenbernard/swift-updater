import Foundation

/// An object that manages updates.
public final class SUUpdater: Sendable {
    /// The bundle to update.
    public let bundle: Bundle

    /// The downloader to download updates.
    public let downloader: SUUpdateDownloader

    /// The extractor to extract updates.
    public let extractor: SUUpdateExtractor?

    /// Creates an updater for the specified bundle using the specified downloader and extractor.
    ///
    /// - Parameters:
    ///   - bundle: The bundle to update. The default is `main`.
    ///   - downloader: The downloader to download updates. The default is ``SUUpdateDownloader/standard(urlSession:)``.
    ///   - extractor: The extractor to extract updates. The default is `nil`.
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
