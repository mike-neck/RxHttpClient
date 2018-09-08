import RxSwift

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
        case basic(credential: String)

        var type: String {
            get {
                switch self {
                case .bearer(_): return "Bearer"
                case .basic(_): return "Basic"
                }
            }
        }

        var value: String {
            get {
                switch self {
                case .bearer(let token): return "\(self.type) \(token)"
                case .basic(let credential): return "\(self.type) \(credential)"
                }
            }
        }
    }

    public var name: String {
        get {
            switch self {
            case .accept(_): return "Accept"
            case .authorization(_): return "Authorization"
            case .userAgent(_): return "User-Agent"
            case .host(_): return "Host"
            }
        }
    }

    public var value: String {
        get {
            switch self {
            case .accept(let value): return value
            case .authorization(let type): return type.value
            case .userAgent(let value): return value
            case .host(let value): return value
            }
        }
    }
}
