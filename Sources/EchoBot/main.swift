
import Foundation
import Telegrammer
import HTTP

guard let token = Enviroment.get("TELEGRAMMER_TOKEN") else {
    exit(1)
}

var bot: Bot!

do {
    let settings = Bot.Settings(token: token, debugMode: true, serverHost: "api.telegram.org", serverPort: 443)
    bot = try Bot(settings: settings)
} catch {
    print(error.localizedDescription)
    exit(1)
}

var userEchoModes: [Int64: Bool] = [:]

func send(message: Bot.SendMessageParams) {
    do {
        try bot.sendMessage(params: message)
    } catch {
        print(error.localizedDescription)
    }
}

func echoModeSwitch(_ update: Update, _ updateQueue: Worker?, _ jobQueue: Worker?) {

    guard let message = update.message else { return }
    guard let user = message.from else { return }
    
    var onText = ""
    if let on = userEchoModes[user.id] {
        onText = on ? "OFF" : "ON"
        userEchoModes[user.id] = !on
    } else {
        onText = "ON"
        userEchoModes[user.id] = true
    }

    let params = Bot.SendMessageParams(chatId: .chat(message.chat.id), text: "Echo mode turned \(onText)")
    send(message: params)
}

func echo(_ update: Update, _ updateQueue: Worker?, _ jobQueue: Worker?) {
	guard let message = update.message else { return }
    guard let user = message.from else { return }
    guard let on = userEchoModes[user.id], on == true else { return }
    let params = Bot.SendMessageParams(chatId: .chat(message.chat.id), text: message.text!)
    send(message: params)
}

do {
    let dispatcher = Dispatcher(bot: bot)
    
    let commandHandler = CommandHandler(commands: ["/echo"], callback: echoModeSwitch)
    dispatcher.add(handler: commandHandler)
    
    let echoHandler = MessageHandler(filters: Filters.text, callback: echo)
    dispatcher.add(handler: echoHandler)
	
    ///Longpolling updates
    try Updater(bot: bot, dispatcher: dispatcher).startLongpolling()

} catch {
    print(error.localizedDescription)
}
