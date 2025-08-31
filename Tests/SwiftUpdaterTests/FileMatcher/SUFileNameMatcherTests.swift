import Testing

import SwiftUpdater

@Suite
struct SUFileNameMatcherTests {
    @Test(arguments: [
        ("", "", true),
        ("", ".", true),
        ("", "a", false),
        ("", "a.b", false),
        ("a", "", false),
        ("a", "a", true),
        ("a", "a.a", true),
        ("a", "a.b", true),
        ("a.b", "", false),
        ("a.b", "a.b", false),
        ("a.b", "a.a.b", false),
        ("a.b", "a.b.c", true)
    ])
    func testMatches(
        file: String,
        fileToMatch: String,
        matches: Bool
    ) {
        let matcher = SUFileNameMatcher(file)
        #expect(matcher.matches(fileToMatch) == matches)
    }
}
