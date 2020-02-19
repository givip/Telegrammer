<p align="center"><img src="https://gp-apps.com/github/telegrammer_logo.png" alt="SwiftyBot Banner"></p>

# Telegrammer
Telegram Bot Framework written in Swift 5.1 with SwiftNIO network framework

[![Build](https://circleci.com/gh/givip/Telegrammer/tree/master.svg?style=shield&circle-token=04a84114573c1c6b3039ef82b88e54f1f6b8c512)](https://circleci.com/gh/givip/Telegrammer)
[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/givip/Telegrammer/releases)
[![Language](https://img.shields.io/badge/language-Swift%205.1-orange.svg)](https://swift.org/download/)
[![Platform](https://img.shields.io/badge/platform-Linux%20/%20macOS-ffc713.svg)](https://swift.org/download/)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/givip/Telegrammer/blob/master/LICENSE)


What does it do
---------------

Telegrammer is open-source framework for Telegram Bots developers.
It was built on top of [Apple/SwiftNIO](https://github.com/apple/swift-nio)

Join to our [Telegram developers chat](https://t.me/joinchat/AzGW3kkUjLoK2dr3CZFrFQ)
Join to our [Telegrammer channel](https://discord.gg/yjspy8b) on [Vapor Discord server](https://discord.gg/3jG8QFV) 

The simplest code of Echo Bot looks like this:

-------------
_main.swift_
```swift
import Foundation
import Telegrammer

do {
    let bot = try Bot(token: "BOT_TOKEN_HERE")

    let echoHandler = MessageHandler { (update, _) in
        _ = try? update.message?.reply(text: "Hello \(update.message?.from?.firstName ?? "anonymous")", from: bot)
    }

    let dispatcher = Dispatcher(bot: bot)
    dispatcher.add(handler: echoHandler)

    _ = try Updater(bot: bot, dispatcher: dispatcher).startLongpolling().wait()
} catch {
    exit(1)
}
```

Documentation
---------------

- Read [An official introduction for developers](https://core.telegram.org/bots) 
- Check out [bot FAQ](https://core.telegram.org/bots/faq)
- Official [Telegram Bot API](https://core.telegram.org/bots/api)


Usage without Vapor
---------------

- Use the template repository as a example [https://github.com/givip/telegrammer-bot-template.git](https://github.com/givip/telegrammer-bot-template.git)
- Current repository contains five examples of bot implementation:
https://github.com/givip/Telegrammer/tree/master/Sources/DemoEchoBot
https://github.com/givip/Telegrammer/tree/master/Sources/DemoHelloBot
https://github.com/givip/Telegrammer/tree/master/Sources/DemoSchedulerBot
https://github.com/givip/Telegrammer/tree/master/Sources/DemoSpellCheckerBot
https://github.com/givip/Telegrammer/tree/master/Sources/DemoWebhooksLocally

Usage with Vapor
---------------

- Use the  [https://github.com/givip/telegrammer-bot-vapor-template.git](https://github.com/givip/telegrammer-bot-vapor-template.git)

Demo bots
---------------

#### All sample bots
1. Add Telegram Token in [Environment Variables](http://nshipster.com/launch-arguments-and-environment-variables/), so, either create an environment variable:
```
$ export TELEGRAM_BOT_TOKEN='000000000:AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
```
2. Run Bot executable scheme or
```
$ swift run
```


[EchoBot sources](https://github.com/givip/Telegrammer/tree/master/Sources/EchoBot)
Starts/stops with command "/echo", then simply responds with your message

[HelloBot sources](https://github.com/givip/Telegrammer/tree/master/Sources/HelloBot)
Says "Hello" to new users in group. Responds with "hello" message on command "/greet"

[SchedulerBot sources](https://github.com/givip/Telegrammer/tree/master/Sources/SchedulerBot)
Demonstrate Jobs Queue scheduling mechanism. 
Command "/start X" starts repeatable job, wich will send you a message each X seconds.
Command "/once X" will send you message once after timeout of X seconds.
Command "/stop" stops JobsQueue only for you. Other users continues to receive scheduled messages.

[SpellCheckerBot sources](https://github.com/givip/Telegrammer/tree/master/Sources/SpellCheckerBot)
Demonstrate how works InlineMenus and Callback handlers.
Command "/start" will start bot.
Send any english text to bot and it will be checked for mistakes. Bot will propose you some fixes in case of found mistake.

Requirements
---------------

- Ubuntu 16.04 or later with [Swift 5.1 or later](https://swift.org/getting-started/) / macOS with [Xcode 11 or later](https://swift.org/download/)
- Telegram account and a Telegram App for any platform
- [Swift Package Manager (SPM)](https://github.com/apple/swift-package-manager/blob/master/Documentation/Usage.md) for dependencies 
- [Vapor 4](https://vapor.codes) (optionally, for bots with database and other server side stuff)

Contributing
---------------

See [CONTRIBUTING.md](CONTRIBUTING.md) file.

Author
---------------

Givi Pataridze

[pataridzegivi@gmail.com](mailto:pataridzegivi@gmail.com)
[@givip](tg://user?id=53581534)
