import XCTest
@testable import RxHttpClient

class RxHttpClientTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(RxHttpClient().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
