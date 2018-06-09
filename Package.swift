// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "RxHttpClient",
    products: [
        .library(name: "RxHttpClient", targets: ["RxHttpClient"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "1.8.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "4.2.0"),
    ],
    targets: [
        .target(name: "RxHttpClient", dependencies: ["NIO", "RxSwift"]),
        .testTarget(name: "RxHttpClientTests", dependencies: ["RxHttpClient", "NIO", "RxSwift"]),
    ]
)
