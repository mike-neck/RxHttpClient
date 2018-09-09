import XCTest
@testable import RxHttpClient
import NIO

class ClientBuilderTest: XCTestCase, Executable {

    static let allTests: [(String, (ClientBuilderTest) -> () -> ())] = [
        ("test_embeddedEventLoop", test_embeddedEventLoop),
        ("test_multiThreadedEventLoop", test_multiThreadedEventLoop),
        ("test_sharedEventLoop", test_sharedEventLoop)
    ]

    var clientLoop: ClientLoop?

    func test_embeddedEventLoop() {
        clientLoop = try! ClientLoopBuilder.embedded()
                .withThreads(count: 2)
                .createClientLoop()

        guard let eventLoop = clientLoop?.eventLoopGroup as? EmbeddedEventLoop else {
            XCTFail("expected embeddedLoop existing but not", file: #file, line: #line)
            return
        }
        XCTAssertNotNil(eventLoop)
    }

    func test_multiThreadedEventLoop() {
        clientLoop = try! ClientLoopBuilder.multiThreadedLoop()
                .withThreads(count: 2)
                .createClientLoop()

        guard let eventLoop = clientLoop?.eventLoopGroup as? MultiThreadedEventLoopGroup else {
            XCTFail("expected multiThreadedEventLoopGroup existing but not", file: #file, line: #line)
            return
        }
        XCTAssertNotNil(eventLoop)
    }

    func test_sharedEventLoop() {
        let eventLoop = EmbeddedEventLoop()
        clientLoop = try! ClientLoopBuilder.shared(eventLoop: eventLoop)
                .createClientLoop()

        guard let actual = clientLoop?.eventLoopGroup as? EmbeddedEventLoop else {
            XCTFail("expected sharedEventLoopGroup existing but not.", file: #file, line: #line)
            return
        }
        XCTAssertTrue(eventLoop === actual)
    }

    override func tearDown() {
        if let loop = clientLoop {
            try! loop.shutdown()
        }
    }
}


