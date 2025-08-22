import Testing

import SwiftUpdater

// swiftlint:disable large_tuple
// swiftlint:disable number_separator

@Suite
struct SUVersionTests {
    @Test(arguments: [
        ("a.b.c", nil),
        ("0..1..2", nil),
        ("3..4..5", nil),
        ("0.1", nil),
        ("2.3", nil),
        ("0.1.2.3", nil),
        ("4.5.6.7", nil),
        ("0.1.2", (0, 1, 2)),
        ("5.4.3", (5, 4, 3)),
        ("67.891.01112", (67, 891, 1112))
    ])
    func testInit(
        string: String,
        versions: (Int, Int, Int)?
    ) {
        let version = SUVersion(string: string)
        #expect(version?.major == versions?.0)
        #expect(version?.minor == versions?.1)
        #expect(version?.patch == versions?.2)
    }

    @Test(arguments: [
        ((0, 1, 2), (0, 1, 2), false),
        ((0, 1, 2), (3, 4, 5), true),
        ((5, 4, 3), (2, 1, 0), false),
        ((0, 3, 4), (1, 2, 3), true),
        ((1, 2, 3), (0, 3, 4), false),
        ((0, 0, 1), (0, 0, 2), true),
        ((0, 0, 2), (0, 0, 1), false),
        ((0, 1, 0), (0, 2, 0), true),
        ((0, 2, 0), (0, 1, 0), false),
        ((1, 0, 0), (2, 0, 0), true),
        ((2, 0, 0), (1, 0, 0), false)
    ])
    func testComparable(
        lhs: (Int, Int, Int),
        rhs: (Int, Int, Int),
        isOrderedBefore: Bool
    ) {
        let lhs = SUVersion(major: lhs.0, minor: lhs.1, patch: lhs.2)
        let rhs = SUVersion(major: rhs.0, minor: rhs.1, patch: rhs.2)
        #expect((lhs < rhs) == isOrderedBefore)
    }
}
