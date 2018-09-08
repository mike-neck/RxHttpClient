import XCTest
@testable import RxHttpClientTests

XCTMain([
    testCase(RequestHeaderTest.allTests),
    testCase(RequestURLTest.allTests),
])
