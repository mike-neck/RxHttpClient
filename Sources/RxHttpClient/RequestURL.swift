public protocol RequestURL {
    var host: String { get }
    var port: Int { get }


}

public struct Url: RequestURL {

    let delegate: RequestURL
    let usingPort: Int?

    public var host: String {
        get {
            return delegate.host
        }
    }

    public var port: Int {
        get {
            return usingPort ?? delegate.port
        }
    }
}

public extension RequestURL {
    public static func to(_ delegate: HttpUrl, port: Int?) -> RequestURL {
        return Url.init(delegate: delegate, usingPort: port)
    }
}

public enum HttpUrl: RequestURL {

    case http(_: String)
    case https(_: String)

    public var host: String {
        get {
            switch self {
            case .http(let addr): return addr
            case .https(let addr): return addr
            }
        }
    }

    public var port: Int {
        get {
            switch self {
            case .http(_): return 80
            case .https(_): return 443
            }
        }
    }
}
