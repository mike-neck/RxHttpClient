import XCTest
import RxHttpClient

class RequestHeaderTest: XCTestCase, Executable {

    func test_acceptHeader() {
        let header: RequestHeader = .accept(mediaType: "application/json")
        XCTAssertEqual("Accept", header.name)
        XCTAssertEqual("application/json", header.value)
    }

    func test_authorizationHeader() {
        let header: RequestHeader = .authorization(authorizationType: .bearer(token: "XXX-AAA"))
        XCTAssertEqual("Authorization", header.name)
        XCTAssertEqual("Bearer XXX-AAA", header.value)
    }

    func test_userAgentHeader() {
        let header: RequestHeader = .userAgent(agentName: "rx-http-client")
        XCTAssertEqual("User-Agent", header.name)
        XCTAssertEqual("rx-http-client", header.value)
    }

    func test_hostHeader() {
        let header: RequestHeader = .host(host: "example.com")
        XCTAssertEqual("Host", header.name)
        XCTAssertEqual("example.com", header.value)
    }

    static let allTests = [
        ("test_acceptHeader", test_acceptHeader),
        ("test_authorizationHeader", test_authorizationHeader),
        ("test_userAgentHeader", test_userAgentHeader),
        ("test_hostHeader", test_hostHeader),
    ]
}

class RequestURLTest: XCTestCase, Executable {

    func test_url() {
        let url = Url.to(.http("localhost"), port: 8000)
        XCTAssertEqual("localhost", url.host)
        XCTAssertEqual(8000, url.port)
    }

    func test_https() {
        let https: HttpUrl = .https("example.com")
        XCTAssertEqual("example.com", https.host)
        XCTAssertEqual(443, https.port)
    }

    static let allTests: [(String, (RequestURLTest) -> () -> ())] = [
        ("test_url", test_url)
    ]
}
