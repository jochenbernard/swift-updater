import Testing

import SwiftUpdater

@Suite
struct SUFileExactMatcherTests {
    @Test(arguments: [
        ("", "", true),
        ("", ".", false),
        ("", "a", false),
        ("", "a.b", false),
        ("a", "", false),
        ("a", "a", true),
        ("a", "a.a", false),
        ("a", "a.b", false),
        ("a.b", "", false),
        ("a.b", "a.b", true),
        ("a.b", "a.a.b", false),
        ("a.b", "a.b.c", false)
    ])
    func testMatches(
        file: String,
        fileToMatch: String,
        matches: Bool
    ) {
        let matcher = SUFileExactMatcher(file)
        #expect(matcher.matches(fileToMatch) == matches)
    }
}
