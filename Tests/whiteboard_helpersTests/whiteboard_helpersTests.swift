import XCTest
@testable import whiteboard_helpers

class whiteboard_helpersTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(whiteboard_helpers().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
