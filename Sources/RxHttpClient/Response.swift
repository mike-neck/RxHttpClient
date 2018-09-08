import NIO
import Foundation

public protocol Response {

    var headers: [HttpHeader] { get }

    func headerValues(of: String) -> [String]

    func headerValue(of: String) -> String?

    var status: Int { get }

    func bodyAsBytes() -> [ByteBuffer]

    func bodyAsString() -> String

    func bodyAs<T>(_ type: T.Type, usingEncoding: String.Encoding) throws -> T
}

public protocol HttpHeader {

    var name: String { get }

    var values: [String] { get }

    var singleValue: String { get }
}
