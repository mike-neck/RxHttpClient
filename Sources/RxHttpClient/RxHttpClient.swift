// sample usage
// let client: HttpClient = RxHttpClient.newClient()
// let response: Single<Response> = httpClient.get(.https("api.example.com"))
//     .path("team/1234/member")
//     .query("page", 2)
//     .query("order", "id")
//     .header("Authorization", "Bearer a1b2c3")
//     .header(.accept("application/json"))
//     .header(.userAgent("my-app"))
//     .asSingle()

import Foundation
import RxSwift
import NIO

protocol RxHttpClientFactory {

    static func newClient() -> HttpClient

    static func newClient(shareLoop loop: HttpClient) -> HttpClient
}

public class RxHttpClient: RxHttpClientFactory {

    public class func newClient() -> HttpClient {
        fatalError("newClient() has not been implemented")
    }

    public class func newClient(shareLoop loop: HttpClient) -> HttpClient {
        fatalError("newClient(eventLoopGroup:) has not been implemented")
    }
}

public protocol HttpClient {

    func get(_ ur: String) -> GetRequest

//    func post(_ url: String) -> PostRequest
//
//    func put(_ url: String) -> PutRequest
//
//    func delete(_ url: String) -> DeleteRequest

    var loop: ClientLoop { get }

    func shutdown() throws
}

//public protocol PostRequest {
//}
//
//public protocol PutRequest {
//}
//
//public protocol DeleteRequest {
//}

