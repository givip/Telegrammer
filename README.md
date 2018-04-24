<p align="center"><img src="http://gp-apps.com/github/telegrammer_logo.png" alt="SwiftyBot Banner"></p>

# Telegrammer
Telegram Bot Framework written in Swift 4.1 with SwiftNIO network framework

[![Version](https://img.shields.io/badge/version-0.1.4-blue.svg)](https://github.com/givip/Telegrammer/releases)
[![Language](https://img.shields.io/badge/language-Swift%204.1-orange.svg)](https://swift.org/download/)
[![Platform](https://img.shields.io/badge/platform-Linux%20/%20macOS-ffc713.svg)](https://swift.org/download/)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/givip/Telegrammer/blob/master/LICENSE)
---

<p align="center">
<a href="#what-does-it-do">What does it do</a> &bull;
<a href="#requirements">Requirements</a> &bull;
<a href="#contributing">Contributing</a> &bull;
<a href="#installing-and-usage">Installing and Usage</a> &bull;
<a href="#documentation">Documentation</a> &bull;
<a href="#demo">Demo</a> &bull;
<a href="#author">Author</a> &bull;
</p>

---

What does it do
---------------

Telegrammer is open-source framework for Telegram Bots developers.
It was built on top of [Apple/SwiftNIO](https://github.com/apple/swift-nio) which help to demonstrate excellent performance.
> SwiftNIO is a cross-platform asynchronous event-driven network application framework for rapid development of maintainable high performance protocol servers and clients.

Also Telegrammer use some submodules of [Vapor 3 server side swift framework](https://github.com/vapor/vapor)


Requirements
---------------

- Ubuntu 14.04 or later with [Swift 4.1 or later](https://swift.org/getting-started/) / macOS with [Xcode 9.3 or later](https://swift.org/download/)
- Telegram account and a Telegram App for any platform
- [Swift Package Manager (SPM)](https://github.com/apple/swift-package-manager/blob/master/Documentation/Usage.md) for dependencies 
- [Vapor 3](https://vapor.codes) (optionally, for bots with database and other server side stuff)

Contributing
---------------

See [CONTRIBUTING.md](docs/CONTRIBUTING.md) file.

Installing and Usage
---------------

1. Create package with Swift Package Manager (SPM)
```
$ mkdir MyBot
$ cd MyBot
$ swift package init --type executable
```
2. Define Dependencies in Package.swift file
```
let package = Package(
name: "MyBot",
dependencies: [
.package(url: "https://github.com/givip/Telegrammer.git", from: "0.1.0"),
],
targets: [
.target( name: "MyBot", dependencies: ["Telegrammer"]),
]
)
```
3. Resolve dependencies
```
$ swift package resolve
```
4. Generate XCode project (for macOS only)
```
$ swift package generate-xcodeproj
```
5. Open in XCode (for macOS only)
```
$ open MyBot.xcodeproj
```
You project is ready to create new Telegram Bot.

If you need more help through this steps, you can read [How to create a Telegram bot with Telegrammer on Ubuntu / macOS](#) (Coming soon...)


Documentation
-------------

- Read [An official introduction for developers](https://core.telegram.org/bots) 
- Check out bot [FAQ](https://core.telegram.org/bots/faq)
- Official [Telegram Bot API](https://core.telegram.org/bots/api)


Demo bots
---------

#### EchoBot Sample
1. Add Telegram Token in [Environment Variables](http://nshipster.com/launch-arguments-and-environment-variables/), e.g. 
```
TELEGRAM_BOT_TOKEN 000000000:AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
```
2. Run EchoBot executable scheme or
```
$ swift run
```
3. Send _**/echo**_ command to bot


Author
------

Givi Pataridze

[pataridzegivi@gmail.com](mailto:pataridzegivi@gmail.com)


