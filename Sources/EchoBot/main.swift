
import Foundation
import Telegrammer
import HTTP

///Getting token from enviroment variable (most safe, recommended)
guard let token = Enviroment.get("TELEGRAMMER_TOKEN") else { exit(1) }

/// Initializind Bot settings (token, mode and webhooks)
let settings = Bot.Settings(token: token, debugMode: true)
let bot = try! Bot(settings: settings)

/// Dictionary for user echo modes
var userEchoModes: [Int64: Bool] = [:]

func echoModeSwitch(_ update: Update, _ updateQueue: Worker?, _ jobQueue: Worker?) throws {
    guard let message = update.message,
        let user = message.from else { return }
    
    var onText = ""
    if let on = userEchoModes[user.id] {
        onText = on ? "OFF" : "ON"
        userEchoModes[user.id] = !on
    } else {
        onText = "ON"
        userEchoModes[user.id] = true
    }

    let params = Bot.SendMessageParams(chatId: .chat(message.chat.id), text: "Echo mode turned \(onText)")
    try bot.sendMessage(params: params)
}

func echoResponse(_ update: Update, _ updateQueue: Worker?, _ jobQueue: Worker?) throws {
    guard let message = update.message,
        let user = message.from,
        let on = userEchoModes[user.id],
        on == true else { return }
    let params = Bot.SendMessageParams(chatId: .chat(message.chat.id), text: message.text!)
    try bot.sendMessage(params: params)
}

do {
    let dispatcher = Dispatcher(bot: bot)
    
    let commandHandler = CommandHandler(commands: ["/echo"], callback: echoModeSwitch)
    dispatcher.add(handler: commandHandler)
    
    let echoHandler = MessageHandler(filters: Filters.text, callback: echoResponse)
    dispatcher.add(handler: echoHandler)
	
    ///Longpolling updates
    try Updater(bot: bot, dispatcher: dispatcher).startLongpolling()

} catch {
    print(error.localizedDescription)
}
