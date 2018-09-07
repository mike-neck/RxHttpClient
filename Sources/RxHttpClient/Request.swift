import Foundation

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
