// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Telegrammer",
    products: [
        .library(name: "Telegrammer", targets: ["Telegrammer"]),
        .executable(name: "EchoBot", targets: ["EchoBot"]),
        .executable(name: "HelloBot", targets: ["HelloBot"]),
        .executable(name: "SchedulerBot", targets: ["SchedulerBot"]),
        .executable(name: "SpellCheckerBot", targets: ["SpellCheckerBot"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/http.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/crypto.git", from: "3.1.0"),
        .package(url: "https://github.com/vapor/multipart.git", from: "3.0.0"),
        .package(url: "https://github.com/apple/swift-log.git", .branch("master"))
    ],
    targets: [
        .target(
            name: "Telegrammer",
            dependencies: ["HTTP", "Multipart", "Crypto", "Logging"]),
        .target(name: "EchoBot", dependencies: ["Telegrammer"]),
        .target(name: "HelloBot", dependencies: ["Telegrammer"]),
        .target(name: "SchedulerBot", dependencies: ["Telegrammer"]),
        .target(name: "SpellCheckerBot", dependencies: ["Telegrammer"]),
        .testTarget(name: "TelegrammerTests", dependencies: ["Telegrammer"])
    ]
)
