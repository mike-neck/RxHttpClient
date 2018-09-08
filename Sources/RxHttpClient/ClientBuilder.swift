import NIO


public protocol ClientLoop {

    var eventLoopGroup: EventLoopGroup { get }

    func shutdown() throws
}

fileprivate protocol EventLoopProvider {
    func eventLoop(threads: Int) -> EventLoopGroup
}

fileprivate enum EventLoopType: EventLoopProvider {
    case multiThread
    case embedded

    func eventLoop(threads: Int) -> EventLoopGroup {
        switch self {
        case .multiThread:
            return MultiThreadedEventLoopGroup(numberOfThreads: threads)
        case .embedded:
            return EmbeddedEventLoop()
        }
    }
}

enum ConfigurationError: Error {
    case invalidNumberOfThreads(message: String)
}

public struct ClientLoopBuilder {

    let threads: Int
    private let type: EventLoopType

    fileprivate init(type: EventLoopType) {
        self.threads = 1
        self.type = type
    }

    private init(type: EventLoopType, threads: Int) {
        self.type = type
        self.threads = threads
    }


    public func withThreads(count: UInt16) -> ClientLoopBuilder {
        let threads = Int(count)
        return ClientLoopBuilder(type: self.type, threads: threads)
    }

    public func createClientLoop() throws -> ClientLoop {
        guard threads > 0 else {
            throw ConfigurationError.invalidNumberOfThreads(message: "Thread count should be larger than 0(current configuration: \(threads)).")
        }
        let eventLoopGroup = type.eventLoop(threads: threads)
        return EventLoopGroupWrapper(eventLoopGroup)
    }
}

public extension ClientLoopBuilder {

    public static func multiThreadedLoop() -> ClientLoopBuilder {
        return ClientLoopBuilder(type: .multiThread)
    }

    public static func embedded() -> ClientLoopBuilder {
        return ClientLoopBuilder(type: .embedded)
    }
}

fileprivate class EventLoopGroupWrapper: ClientLoop {

    let eventLoopGroup: EventLoopGroup

    init(_ eventLoopGroup: EventLoopGroup) {
        self.eventLoopGroup = eventLoopGroup
    }

    func shutdown() throws {
        try eventLoopGroup.syncShutdownGracefully()
    }
}
