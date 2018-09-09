import Foundation
@testable import RxHttpClient
import NIO
import XCTest

class Option: HttpClientOption {

    var receive: [Any] = []

    func configure<T: ChannelOption>(option: T, value: T.OptionType) -> HttpClientOption {
        receive.append(value)
        return self
    }
}

class ClientConnectionConfigurationTest: XCTestCase, Executable {

    private(set) static var allTests: [(String, (ClientConnectionConfigurationTest) -> () -> ())] = [
        ("test_emptyConfigurationDoesNothing", test_emptyConfigurationDoesNothing),
        ("test_singleConfigurationDoes1Config", test_singleConfigurationDoes1Config),
        ("test_multipleConfig", test_multipleConfig),
        ("test_configureTheSameOptionMultipleTimes", test_configureTheSameOptionMultipleTimes),
    ]

    func test_emptyConfigurationDoesNothing() {
        let configuration = HttpClientConnectionConfiguration()
        let result = configuration.apply(option: Option())

        guard let actual = result as? Option else {
            XCTFail("expected instance of Option but not")
            return
        }

        XCTAssertEqual(0, actual.receive.count)
    }

    func test_singleConfigurationDoes1Config() {
        let configuration = HttpClientConnectionConfiguration()
        let config: ClientConnectionConfiguration = configuration
        _ = config.enableSoReuseAddr()
        let result = configuration.apply(option: Option())

        guard let option = result as? Option else {
            XCTFail("expected instance of Option but not")
            return
        }

        XCTAssertEqual([SoReuseAddr.enable.channelOptionValue!], option.receive.map {
            $0 as! SocketOptionValue
        })
    }

    func test_multipleConfig() {
        let configuration = HttpClientConnectionConfiguration()
        let config: ClientConnectionConfiguration = configuration

        _ = config.enableSoReuseAddr()
                .enableTcpNoDelay()

        let result = configuration.apply(option: Option())

        guard let option = result as? Option else {
            XCTFail("expected instance of Option but not")
            return
        }

        XCTAssertTrue( option.receive.contains(where: value(of: SoReuseAddr.enable.channelOptionValue!)) )
        XCTAssertTrue( option.receive.contains(where: value(of: TcpNoDelay.noDelay.channelOptionValue!)) )
    }

    private func value<T: Equatable>(of v: T) -> (Any) -> Bool {
        return { any in
            let actual = any as! T
            return actual == v
        }
    }

    func test_configureTheSameOptionMultipleTimes() {
        let configuration = HttpClientConnectionConfiguration()
        let config: ClientConnectionConfiguration = configuration

        _ = config.enableSoReuseAddr().disableSoReuseAddr()

        let result = configuration.apply(option: Option())

        guard let actual = result as? Option else {
            XCTFail("expected instance of Option but not")
            return
        }

        XCTAssertEqual(0, actual.receive.count)
    }
}
