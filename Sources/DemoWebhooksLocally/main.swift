//
//  File.swift
//  
//
//  Created by Givi on 27.11.2019.
//

// swiftlint:disable all

import Foundation
import Telegrammer
import Logging
import NIO

// swiftlint:disable all

/**
 Launch this target and try to send requests with updates to you server, they should appear in console.
 You can check manual from Telegram API website:
 https://core.telegram.org/bots/webhooks#testing-your-bot-with-updates
 !!!Be careful, examples of jsons on this site are outdated!!!

Working example:

 curl --tlsv1 -v -k -X POST -H "Content-Type: application/json" -H "Cache-Control: no-cache"  -d '{
 "update_id" : 261995970,
 "message" : {
 "from" : {
 "username" : "givip",
 "id" : 53581534,
 "language_code" : "en",
 "is_bot" : false,
 "first_name" : "Givi"
 },
 "chat" : {
 "username" : "givip",
 "id" : 53581534,
 "type" : "private",
 "first_name" : "Givi"
 },
 "message_id" : 6492,
 "text" : "dfd",
 "date" : 1574871485
 }
 }' "http://127.0.0.1:8080/"

 */

let log = Logger(label: "com.webhooks.test")

var settings = Bot.Settings(token: "BOT_TOKEN")
settings.webhooksConfig = Webhooks.Config(
    ip: "127.0.0.1",
    url: "",
    port: 8080
)

let bot = try! Bot(settings: settings)

let dispatcher = Dispatcher(bot: bot)
dispatcher.add(handler: LoggerHandler(level: .info))

let webhooks = Webhooks(bot: bot, dispatcher: dispatcher)

let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
let promise = group.next().makePromise(of: Void.self)

try! webhooks
    .start()
    .whenComplete { (result) in
        switch result {
        case .failure(let error):
            log.error(error.logMessage)
        case .success:
            log.info("Updates server started successfully, waiting for requests.")
        }
}

try! promise.futureResult.wait()
