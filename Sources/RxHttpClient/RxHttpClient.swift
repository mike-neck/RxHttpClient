// sample usage
// let client: RxHttpClient = RxHttpClient.newClient()
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

public protocol RxHttpClient {

    func get(_ ur: String) -> GetRequest

//    func post(_ url: String) -> PostRequest
//
//    func put(_ url: String) -> PutRequest
//
//    func delete(_ url: String) -> DeleteRequest

    static func newClient() -> RxHttpClient

    static func newClient(on eventLoopGroup: EventLoopGroup) -> RxHttpClient
}

//public protocol PostRequest {
//}
//
//public protocol PutRequest {
//}
//
//public protocol DeleteRequest {
//}

