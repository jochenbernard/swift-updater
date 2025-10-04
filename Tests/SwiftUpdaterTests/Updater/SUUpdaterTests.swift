import Foundation
import Testing

import SwiftUpdater

// swiftlint:disable force_unwrapping

@Suite
struct SUUpdaterTests {
    @MainActor
    @Test(arguments: [
        URL(string: "https://a.b")!,
        URL(string: "https://a.b/c")!,
        URL(string: "https://a.b/c/d")!,
        URL(string: "https://a.b.c")!,
        URL(string: "https://a.b.c/d")!,
        URL(string: "https://a.b.c/d/e")!
    ])
    func testUpdate(updateURL: URL) {
        let updater = SUUpdater()
        let update = updater.update(from: updateURL)

        guard case .waiting = update.state else {
            Issue.record("Update state is not waiting")
            return
        }

        #expect(update.url == updateURL)
    }
}
