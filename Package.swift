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
        .executable(name: "EchoBot", targets: ["DemoEchoBot"]),
        .executable(name: "HelloBot", targets: ["DemoHelloBot"]),
        .executable(name: "SchedulerBot", targets: ["DemoSchedulerBot"]),
        .executable(name: "SpellCheckerBot", targets: ["DemoSpellCheckerBot"]),
        .executable(name: "WebhooksLocally", targets: ["DemoWebhooksLocally"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.2.0"),
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.0.0"),
        .package(url: "https://github.com/vapor/multipart-kit.git", from: "4.0.0-beta")
    ],
    targets: [
        .target(
            name: "Telegrammer",
            dependencies: ["AsyncHTTPClient", "MultipartKit", "Logging"]
        ),
        .target(name: "DemoEchoBot", dependencies: ["Telegrammer"]),
        .target(name: "DemoHelloBot", dependencies: ["Telegrammer"]),
        .target(name: "DemoSchedulerBot", dependencies: ["Telegrammer"]),
        .target(name: "DemoSpellCheckerBot", dependencies: ["Telegrammer"]),
        .target(name: "DemoWebhooksLocally", dependencies: ["Telegrammer"]),
        .testTarget(name: "TelegrammerTests", dependencies: ["Telegrammer"])
    ]
)
