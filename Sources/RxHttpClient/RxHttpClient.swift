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

    static func newClient()
}

public protocol HttpHeader {

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

    mutating func asSingle() -> Single<Response>

    mutating func wait() -> Response
}

public enum RequestHeader {
    case accept(mediaType: String)
    case authorization(authorizationType: AuthorizationType)
    case userAgent(agentName: String)
    case host(host: String)

    public enum AuthorizationType {
        case bearer(token: String)
        case basic(userAndPassword: String)
    }
}

public protocol GetRequestHeader: Request {

    func header(name: String, value: String) -> GetRequestHeader

    func header(_ header: RequestHeader) -> GetRequestHeader
}

public protocol GetRequestQuery: GetRequestHeader {

    func query(name: String, value: String) -> GetRequestQuery

    func query(name: String, values: [String]) -> GetRequestQuery
}

public protocol GetRequest: GetRequestQuery {
    func path(_ path: String) -> GetRequestQuery
}


//public protocol PostRequest {
//}
//
//public protocol PutRequest {
//}
//
//public protocol DeleteRequest {
//}

