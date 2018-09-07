import Foundation

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
