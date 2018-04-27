
import Telegrammer
import HeliumLogger
import LoggerAPI
import HTTP

guard let token = Enviroment.get("TELEGRAM_BOT_TOKEN") else {
    exit(1)
}

var bot: Bot!

do {
    bot = try Bot(token: token, host: "api.telegram.org", port: 443)
} catch {
    print(error.localizedDescription)
    exit(1)
}

var userEchoModes: [Int64: Bool] = [:]

func echoModeSwitch(_ update: Update, _ updateQueue: Worker?, _ jobQueue: Worker?) {
    
    guard let user = update.message?.from else { return }
    
    var onText = ""
    if let on = userEchoModes[user.id] {
        onText = on ? "OFF" : "ON"
        userEchoModes[user.id] = !on
    } else {
        onText = "ON"
        userEchoModes[user.id] = true
    }

    let params = Bot.SendMessageParams(chatId: .chat(update.message!.chat.id), text: "Echo mode turned \(onText)")
    _ = try! bot.sendMessage(params: params)
}

func echo(_ update: Update, _ updateQueue: Worker?, _ jobQueue: Worker?) {
    guard let user = update.message?.from else { return }
    guard let on = userEchoModes[user.id], on == true else { return }
    let params = Bot.SendMessageParams(chatId: .chat(update.message!.chat.id), text: update.message!.text!)
    do {
        _ = try bot.sendMessage(params: params)
    } catch {
        Log.error(error.localizedDescription)
    }
}

do {
    let dispatcher = Dispatcher(bot: bot)
    
    let commandHandler = CommandHandler(commands: ["/echo"], callback: echoModeSwitch)
    dispatcher.add(handler: commandHandler)
    
    let echoHandler = MessageHandler(filters: Filters.text, callback: echo)
    dispatcher.add(handler: echoHandler)
    
    _ = try Updater(bot: bot, dispatcher: dispatcher).longpolling().wait()

} catch {
    print(error.localizedDescription)
}


