// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Telegrammer",
    products: [
        .library(name: "Telegrammer", targets: ["Telegrammer"]),
        .executable(name: "EchoBot", targets: ["EchoBot"]),
        .executable(name: "HelloBot", targets: ["HelloBot"])
    ],
    dependencies: [
        .package(url: "https://github.com/givip/http.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/crypto.git", from: "3.1.0"),
        .package(url: "https://github.com/vapor/multipart.git", from: "3.0.0"),
        .package(url: "https://github.com/IBM-Swift/HeliumLogger.git", from: "1.7.0")
    ],
    targets: [
        .target(
            name: "Telegrammer",
            dependencies: ["HTTP", "Multipart", "Crypto", "HeliumLogger"]),
        .target(name: "EchoBot", dependencies: ["Telegrammer"]),
        .target(name: "HelloBot", dependencies: ["Telegrammer"])
    ]
)
