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

    public func get(_ ur: String) -> GetRequest

//    public func post(_ url: String) -> PostRequest
//
//    public func put(_ url: String) -> PutRequest
//
//    public func delete(_ url: String) -> DeleteRequest

    public static func newClient() -> RxHttpClient

    public static func newClient(on eventLoopGroup: EventLoopGroup) -> RxHttpClient

    public static func newClient()
}

protocol HttpHeader {

    var name: String { get }

    var values: [String] { get }

    var singleValue: String { get }
}

public protocol Response {

    var headers: [HttpHeader] { get }

    func headerValues(of: String) -> [String]

    func headerValue(of: String) -> String?

    var status: Int { get }

    func bodyAsByte() -> [ByteBuffer]

    func bodyAsString() -> String

    func bodyAs<T>(_ type: T.Type, usingEncoding: String.Encoding) throws -> T
}

public protocol Request {

    public mutating func asSingle() -> Single<Response>

    public mutating func wait() -> Response
}

public enum RequestHeader {
    case accept(mediaType: String)
    case authorization(authorizationType: AuthorizationType)
    case userAgent(agentName: String)
    internal case host(host: String)

    public enum AuthorizationType {
        case bearer(token: String)
        case basic(userAndPassword: String)
    }
}

public protocol GetRequestHeader: Request {

    associatedtype GetRequestBuilder: GetRequestHeader

    public func header(name: String, value: String) -> GetRequestBuilder

    public func header(_ header: RequestHeader) -> GetRequestBuilder
}

extension GetRequestHeader {
    typealias GetRequestBuilder = GetRequestHeader
}

public protocol GetRequestQuery: GetRequestHeader {

    public func query(name: String, value: String) -> GetRequestQuery

    public func query(name: String, values: [String]) -> GetRequestQuery
}

public protocol GetRequest: GetRequestQuery {
    public func path(_ path: String) -> GetRequestQuery
}


//public protocol PostRequest {
//}
//
//public protocol PutRequest {
//}
//
//public protocol DeleteRequest {
//}

