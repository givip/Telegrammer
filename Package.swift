// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Telegrammer",
    platforms: [
        .macOS(.v10_14)
    ],
    products: [
        .library(name: "Telegrammer", targets: ["Telegrammer"]),
        .executable(name: "EchoBot", targets: ["EchoBot"]),
        .executable(name: "HelloBot", targets: ["HelloBot"]),
        .executable(name: "SchedulerBot", targets: ["SchedulerBot"]),
        .executable(name: "SpellCheckerBot", targets: ["SpellCheckerBot"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.0.0"),
        .package(url: "https://github.com/vapor/multipart-kit.git", from: "4.0.0-beta"),
        .package(url: "https://github.com/vapor/open-crypto.git", from: "4.0.0-alpha.2"),
    ],
    targets: [
        .target(
            name: "Telegrammer",
            dependencies: ["AsyncHTTPClient", "MultipartKit", "OpenCrypto", "Logging"]),
        .target(name: "EchoBot", dependencies: ["Telegrammer"]),
        .target(name: "HelloBot", dependencies: ["Telegrammer"]),
        .target(name: "SchedulerBot", dependencies: ["Telegrammer"]),
        .target(name: "SpellCheckerBot", dependencies: ["Telegrammer"]),
        .testTarget(name: "TelegrammerTests", dependencies: ["Telegrammer"])
    ]
)
