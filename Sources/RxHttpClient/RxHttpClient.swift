// sample usage
// let client: RxHttpClient = RxHttpClient.newClient()
// let response: Observable<Response> = httpClient.get("https://api.example.com")
//     .with(
//       .path("team/1234/member"),
//       .header("Authentication", "Bearer a1b2c3"),
//       .accept("application/json"),
//       .query("page", 2),
//       .query("order", "id"),
//     )
//     .execute()

import Foundation
import RxSwift
import NIO

public protocol RxHttpClient {

    func get(_ ur: String) -> Get

    func post(_ url: String) -> Post

    func put(_ url: String) -> Put

    func delete(_ url: String) -> Delete

    static func newClient() -> RxHttpClient
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

    func header(name: String, value: String) -> Request

    func execute() -> Single<Response>
}

public protocol GetPathExtensible {

}

public protocol Get: Request {}

public protocol Post: Request {}

public protocol Put: Request {}

public protocol Delete: Request {}

