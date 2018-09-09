import NIO

// not Thread safe
public protocol ClientConnectionConfiguration {

    func disableSoReuseAddr() -> ClientConnectionConfiguration

    func enableSoReuseAddr() -> ClientConnectionConfiguration

    func disableTcpNoDelay() -> ClientConnectionConfiguration

    func enableTcpNoDelay() -> ClientConnectionConfiguration

    func useFixedSizedRecvAllocator() -> ClientConnectionConfiguration

    func useAdaptiveRecvAllocator() -> ClientConnectionConfiguration

    func recvAllocatorNotSpecified() -> ClientConnectionConfiguration
}

typealias HttpClientOptionConfiguration = (HttpClientOption) -> HttpClientOption

class HttpClientConnectionConfiguration {

    var configurations: Dictionary<String, HttpClientOptionConfiguration>

    init() {
        self.configurations = [:]
    }

    init(configurations: Dictionary<String, HttpClientOptionConfiguration>) {
        self.configurations = configurations
    }

    func applyConfiguration<T: ChannelOptionProvider>(_ value: T)
                    -> HttpClientOptionConfiguration {
        return { httpClientOption in
            guard let optionValue = value.channelOptionValue else {
                return httpClientOption
            }
            return httpClientOption.configure(option: value.channelOption, value: optionValue)
        }
    }

    func configure<T: ChannelOptionProvider>(option: T.Type, value: T) -> HttpClientConnectionConfiguration {
        configurations[String(describing: type(of: option))] = applyConfiguration(value)
        return self
    }

    func apply(option: HttpClientOption) -> HttpClientOption {
        return configurations.values
                .reduce(option) { (clientOption: HttpClientOption, config: HttpClientOptionConfiguration) -> HttpClientOption in
            return config(clientOption)
        }
    }
}

extension HttpClientConnectionConfiguration: ClientConnectionConfiguration {

    public func recvAllocator(config: RecvAllocatorType) -> ClientConnectionConfiguration {
        return configure(option: RecvAllocatorType.self, value: config)
    }

    public func soReuseAddr(_ config: SoReuseAddr) -> ClientConnectionConfiguration {
        return configure(option: SoReuseAddr.self, value: config)
    }

    public func tcpNoDelay(config: TcpNoDelay) -> ClientConnectionConfiguration {
        return configure(option: TcpNoDelay.self, value: config)
    }

    public func disableSoReuseAddr() -> ClientConnectionConfiguration {
        return soReuseAddr(.disable)
    }

    public func enableSoReuseAddr() -> ClientConnectionConfiguration {
        return soReuseAddr(.enable)
    }

    public func disableTcpNoDelay() -> ClientConnectionConfiguration {
        return tcpNoDelay(config: .noDelay)
    }

    public func enableTcpNoDelay() -> ClientConnectionConfiguration {
        return tcpNoDelay(config: .delayAck)
    }

    public func useFixedSizedRecvAllocator() -> ClientConnectionConfiguration {
        return recvAllocator(config: .fixedSize)
    }

    public func useAdaptiveRecvAllocator() -> ClientConnectionConfiguration {
        return recvAllocator(config: .adaptive)
    }

    public func recvAllocatorNotSpecified() -> ClientConnectionConfiguration {
        return recvAllocator(config: .notSpecified)
    }
}

protocol ChannelOptionProvider {

    associatedtype ChannelOptionType: ChannelOption

    var channelOption: ChannelOptionType { get }
    var channelOptionValue: ChannelOptionType.OptionType? { get }
}

public enum RecvAllocatorType {

    case adaptive
    case fixedSize
    case notSpecified
}

extension RecvAllocatorType: ChannelOptionProvider {

    typealias ChannelOptionType = RecvAllocatorOption

    var channelOption: RecvAllocatorOption {
        return ChannelOptions.recvAllocator
    }

    var channelOptionValue: RecvByteBufferAllocator? {
        switch self {
        case .notSpecified: return nil
        case .adaptive: return AdaptiveRecvByteBufferAllocator()
        case .fixedSize: return FixedSizeRecvByteBufferAllocator(capacity: 8192)
        }
    }
}

public struct SockOptionName {
    let value: Int32

    static var soReuseAddr: SockOptionName {
        return SockOptionName(value: SO_REUSEADDR)
    }

    static var tcpNoDelay: SockOptionName {
        return SockOptionName(value: TCP_NODELAY)
    }
}

public struct SockOptionLevel {
#if os(Linux)
    let value: Int
#else
    let value: Int32
#endif

    static var solSocket: SockOptionLevel {
        return SockOptionLevel(value: SocketOptionLevel(SOL_SOCKET))
    }

    static var ipProtoTcp: SockOptionLevel {
        return SockOptionLevel(value: IPPROTO_TCP)
    }
}

public struct SockOptionValue {
#if os(Linux)
    let value: Int
#else
    let value: Int32
#endif
}

enum SoReuseAddr {
    case enable
    case disable
}

extension SoReuseAddr: ChannelOptionProvider {

    typealias ChannelOptionType = SocketOption

    var channelOption: SocketOption {
        return ChannelOptions.socket(SockOptionLevel.solSocket.value, SockOptionName.soReuseAddr.value)
    }

    var channelOptionValue: ChannelOptionType.OptionType? {
        switch self {
        case .enable: return SocketOptionValue(1)
        case .disable: return nil
        }
    }
}

enum TcpNoDelay {

    case noDelay
    case delayAck
}

extension TcpNoDelay: ChannelOptionProvider {

    typealias ChannelOptionType = SocketOption

    var channelOption: SocketOption {
        return ChannelOptions.socket(SockOptionLevel.ipProtoTcp.value, SockOptionName.tcpNoDelay.value)
    }

    var channelOptionValue: ChannelOptionType.OptionType? {
        switch self {
        case .noDelay: return SocketOptionValue(1)
        case .delayAck: return nil
        }
    }
}
