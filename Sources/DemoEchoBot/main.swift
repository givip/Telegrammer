import Foundation
import Telegrammer

///Getting token from enviroment variable (most safe, recommended)
guard let token = Enviroment.get("TELEGRAM_BOT_TOKEN") else {
    print("TELEGRAM_BOT_TOKEN variable wasn't found in enviroment variables")
    exit(1)
}

/// Initializind Bot settings (token, debugmode)
var settings = Bot.Settings(token: token)

///Webhooks settings, uncomment if you are testing Webhooks
//settings.webhooksConfig = Webhooks.Config(
//    ip: Enviroment.get("TELEGRAM_BOT_IP")!,
//    url: Enviroment.get("TELEGRAM_BOT_WEBHOOK_URL")!,
//    port: Int(Enviroment.get("TELEGRAM_BOT_PORT")!)!,
//    publicCert: .text(content: Enviroment.get("TELEGRAM_BOT_PUBLIC_KEY")!)
//)

let bot = try! Bot(settings: settings)

/// Dictionary for user echo modes
var userEchoModes: [Int64: Bool] = [:]

///Callback for Command handler, which send Echo mode status for user
func echoModeSwitch(_ update: Update, _ context: BotContext?) throws {
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

    let params = Bot.SendMessageParams(
        chatId: .chat(message.chat.id),
        text: "Echo mode turned \(onText)"
    )
    try bot.sendMessage(params: params)
}

///Callback for Message handler, which send echo message to user
func echoResponse(_ update: Update, _ context: BotContext?) throws {
    guard let message = update.message,
        let user = message.from,
        let on = userEchoModes[user.id],
        on == true else { return }
    let params = Bot.SendMessageParams(chatId: .chat(message.chat.id), text: message.text!)
    try bot.sendMessage(params: params)
}

do {
    ///Dispatcher - handle all incoming messages
    let dispatcher = Dispatcher(bot: bot)

    ///Creating and adding handler for command /echo
    let commandHandler = CommandHandler(commands: ["/echo"], callback: echoModeSwitch)
    dispatcher.add(handler: commandHandler)

    ///Creating and adding handler for ordinary text messages
    let echoHandler = MessageHandler(filters: Filters.text, callback: echoResponse)
    dispatcher.add(handler: echoHandler)

    ///Longpolling updates
    _ = try Updater(bot: bot, dispatcher: dispatcher).startLongpolling().wait()

} catch {
    print(error.localizedDescription)
}
