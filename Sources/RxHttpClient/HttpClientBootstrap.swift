import NIO

typealias ChannelOptionConfiguration = (ClientBootstrap) -> ClientBootstrap

public protocol HttpClientOption {

    func configure<T: ChannelOption>(option: T, value: T.OptionType) -> HttpClientOption
}

public protocol HttpClientBootstrap {

}
