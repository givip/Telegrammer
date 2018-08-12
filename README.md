<p align="center"><img src="http://gp-apps.com/github/telegrammer_logo.png" alt="SwiftyBot Banner"></p>

# Telegrammer
Telegram Bot Framework written in Swift 4.1 with SwiftNIO network framework

[![Build](https://circleci.com/gh/givip/Telegrammer/tree/master.svg?style=shield&circle-token=04a84114573c1c6b3039ef82b88e54f1f6b8c512)](https://circleci.com/gh/givip/Telegrammer)
[![Version](https://img.shields.io/badge/version-0.3.1-blue.svg)](https://github.com/givip/Telegrammer/releases)
[![Language](https://img.shields.io/badge/language-Swift%204.1-orange.svg)](https://swift.org/download/)
[![Platform](https://img.shields.io/badge/platform-Linux%20/%20macOS-ffc713.svg)](https://swift.org/download/)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/givip/Telegrammer/blob/master/LICENSE)

---

<p align="center">
<a href="#what-does-it-do">What does it do</a> &bull;
<a href="#documentation">Documentation</a> &bull;
<a href="#howto-guides">HOWTO Guides</a> &bull;
<a href="#usage-without-vapor">Usage without Vapor</a> &bull;
<a href="#usage-with-vapor">Usage with Vapor</a> &bull;
<a href="#demo-bots">Demo bots</a> &bull;
<a href="#requirements">Requirements</a> &bull;
<a href="#contributing">Contributing</a> &bull;
<a href="#author">Author</a> &bull;
</p>

---

What does it do
---------------

Telegrammer is open-source framework for Telegram Bots developers.
It was built on top of [Apple/SwiftNIO](https://github.com/apple/swift-nio) which help to demonstrate excellent performance.
> SwiftNIO is a cross-platform asynchronous event-driven network application framework for rapid development of maintainable high performance protocol servers and clients.

Also Telegrammer use some submodules of [Vapor 3 server side swift framework](https://github.com/vapor/vapor)

Join to our [Telegram developers chat](https://t.me/joinchat/AzGW3kkUjLoK2dr3CZFrFQ)

Join to our [Telegrammer channel](https://discord.gg/yjspy8b) on [Vapor Discord server](https://discord.gg/3jG8QFV) 

It's easy, from scratch
-------------
_main.swift_
```swift
import Telegrammer

let bot = try! Bot(token: "BOT_TOKEN_HERE")

let commandHandler = CommandHandler(commands: ["/hello"], callback: { (update, _) in
    guard let message = update.message, let user = message.from else { return }
    try! message.reply("Hello \(user.firstName)", from: bot)
})

let dispatcher = Dispatcher(bot: bot)
dispatcher.add(handler: commandHandler)

_ = try! Updater(bot: bot, dispatcher: dispatcher).startLongpolling().wait()
```

Documentation
-------------

- Read [An official introduction for developers](https://core.telegram.org/bots) 
- Check out [bot FAQ](https://core.telegram.org/bots/faq)
- Official [Telegram Bot API](https://core.telegram.org/bots/api)

HOWTO Guides
-------------

- [Create Telegram Bot](https://core.telegram.org/bots#3-how-do-i-create-a-bot)
- [Setup Telegram Bot webhooks](https://core.telegram.org/bots/webhooks)

Usage without Vapor
---------------

1. Create package with Swift Package Manager (SPM)
```
$ mkdir MyBot
$ cd MyBot
$ swift package init --type executable
```
2. Define Dependencies in Package.swift file
```swift
let package = Package(
    name: "MyBot",
    dependencies: [
        .package(url: "https://github.com/givip/Telegrammer.git", from: "0.2.0")
        ],
    targets: [
        .target( name: "MyBot", dependencies: ["Telegrammer"])
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

If you need more help through this steps, you can read [How to create a Telegram bot with Telegrammer on Ubuntu / macOS](https://github.com/givip/Telegrammer/wiki/Creating-Telegram-bot-in-Swift)

Usage with Vapor
---------------

You may also use previous way to create project with Vapor, only include Vapor as dependency in Package.swift

1. Install [Vapor CLI](https://docs.vapor.codes/3.0/install/macos/)
```
$ brew install vapor/tap/vapor
```
2. Create Vapor project with [Telegrammer template](https://github.com/givip/telegram-bot-template/)
```
$ vapor new MyBot --template=https://github.com/givip/telegram-bot-template
```
3. Generate XCode project
```
$ vapor xcode
```

Demo bots
---------

#### EchoBot Sample
1. Add Telegram Token in [Environment Variables](http://nshipster.com/launch-arguments-and-environment-variables/), so, either create an environment variable:
```
$ export TELEGRAM_BOT_TOKEN='000000000:AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
```
2. Run EchoBot executable scheme or
```
$ swift run
```
3. Send _**/echo**_ command to bot


Requirements
---------------

- Ubuntu 14.04 or later with [Swift 4.1 or later](https://swift.org/getting-started/) / macOS with [Xcode 9.3 or later](https://swift.org/download/)
- Telegram account and a Telegram App for any platform
- [Swift Package Manager (SPM)](https://github.com/apple/swift-package-manager/blob/master/Documentation/Usage.md) for dependencies 
- [Vapor 3](https://vapor.codes) (optionally, for bots with database and other server side stuff)

Contributing
---------------

See [CONTRIBUTING.md](CONTRIBUTING.md) file.

Author
------

Givi Pataridze

[pataridzegivi@gmail.com](mailto:pataridzegivi@gmail.com)
