// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Telegrammer",
    platforms: [
        .macOS(.v10_14)
    ],
    products: [
        .library(name: "Telegrammer", targets: ["Telegrammer"]),
        .library(name: "TelegrammerMultipart", targets: ["TelegrammerMultipart"]),
        .library(name: "TelegrammerCMultipartParser", targets: ["TelegrammerCMultipartParser"]),
        .executable(name: "EchoBot", targets: ["DemoEchoBot"]),
        .executable(name: "HelloBot", targets: ["DemoHelloBot"]),
        .executable(name: "SchedulerBot", targets: ["DemoSchedulerBot"]),
        .executable(name: "SpellCheckerBot", targets: ["DemoSpellCheckerBot"]),
        .executable(name: "WebhooksLocally", targets: ["DemoWebhooksLocally"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.2.0"),
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.1.0"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.18.0")
    ],
    targets: [
        .target(
            name: "Telegrammer",
            dependencies: [
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "Logging", package: "swift-log"),
                .target(name: "TelegrammerMultipart")
            ]
        ),
        .target(name: "TelegrammerCMultipartParser"),
        .target(
            name: "TelegrammerMultipart",
            dependencies: [
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "NIOHTTP1", package: "swift-nio"),
                .target(name: "TelegrammerCMultipartParser")
            ]
        ),
        .target(name: "DemoEchoBot", dependencies: ["Telegrammer"]),
        .target(name: "DemoHelloBot", dependencies: ["Telegrammer"]),
        .target(name: "DemoSchedulerBot", dependencies: ["Telegrammer"]),
        .target(name: "DemoSpellCheckerBot", dependencies: ["Telegrammer"]),
        .target(name: "DemoWebhooksLocally", dependencies: ["Telegrammer"]),
        .testTarget(name: "TelegrammerTests", dependencies: ["Telegrammer"]),
        .testTarget(name: "TelegrammerMultipartTests", dependencies: ["TelegrammerCMultipartParser"])
    ]
)
