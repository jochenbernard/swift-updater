import Testing

import SwiftUpdater

@Suite
struct SUProgressTests {
    @Test(arguments: [
        (SUProgress.fraction(-1.0), -1.0),
        (SUProgress.fraction(0.0), 0.0),
        (SUProgress.fraction(0.5), 0.5),
        (SUProgress.fraction(1.0), 1.0),
        (SUProgress.fraction(2.0), 2.0),
        (SUProgress.bytes(completed: 0, total: 0), 0.0),
        (SUProgress.bytes(completed: -1, total: 1), -1.0),
        (SUProgress.bytes(completed: 0, total: 2), 0.0),
        (SUProgress.bytes(completed: 2, total: 4), 0.5),
        (SUProgress.bytes(completed: 8, total: 8), 1.0),
        (SUProgress.bytes(completed: 32, total: 16), 2.0)
    ])
    func testFraction(
        progress: SUProgress,
        expectedFraction: Double
    ) {
        #expect(progress.fraction == expectedFraction)
    }
}
