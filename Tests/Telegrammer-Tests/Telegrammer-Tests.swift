import XCTest
@testable import telegrammer_nio

final class Telegrammer-Tests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Telegrammer().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
