import Testing

import SwiftUpdater

@Suite
struct SUFileExtensionMatcherTests {
    @Test(arguments: [
        ("", "", false),
        ("", ".", true),
        ("", "a", false),
        ("", "a.b", false),
        ("a", "", false),
        ("a", "a", false),
        ("a", "a.a", true),
        ("a", "a.b", false),
        ("a.b", "", false),
        ("a.b", "a.b", false),
        ("a.b", "a.a.b", true),
        ("a.b", "a.b.c", false)
    ])
    func testMatches(
        file: String,
        fileToMatch: String,
        matches: Bool
    ) {
        let matcher = SUFileExtensionMatcher(file)
        #expect(matcher.matches(fileToMatch) == matches)
    }
}
