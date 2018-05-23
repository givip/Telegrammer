
import Foundation
import Telegrammer
import HTTP

guard let token = Enviroment.get("TELEGRAMMER_TOKEN") else {
    exit(1)
}

let bot: Bot!

do {
    bot = try Bot(token: token, host: "api.telegram.org", port: 443)
} catch {
    print(error.localizedDescription)
    exit(1)
}

func send(message: Bot.SendMessageParams) {
    do {
        try bot.sendMessage(params: message)
    } catch {
        print(error.localizedDescription)
    }
}

func greetNewMember(_ update: Update) {
    guard let message = update.message else { return }
    guard let newUsers = message.newChatMembers else { return }
    
    for user in newUsers {
        guard !user.isBot else { continue }
        
        var name = user.firstName
        if let username = user.username {
            name = "@\(username)"
        }
        
        let params = Bot.SendMessageParams(chatId: .chat(message.chat.id), text: """
            Hey \(name)!\nI'm HelloBot, written in Swift with Telegrammer framework, please feel free to ask questions in this group chat!
            """)
        send(message: params)
    }
}

func greeting(_ update: Update, _ updateQueue: Worker?, _ jobQueue: Worker?) {
    guard let message = update.message else { return }
    guard let user = message.from else { return }
    
    let params = Bot.SendMessageParams(chatId: .chat(message.chat.id), text: "Hello, \(user.firstName)!")
    send(message: params)
}

do {
    let dispatcher = Dispatcher(bot: bot)
    dispatcher.add(handler: NewMemberHandler(callback: greetNewMember))
    dispatcher.add(handler: CommandHandler(commands: ["/greet"], callback: greeting))
    
    ///Longpolling updates
//    try Updater(bot: bot, dispatcher: dispatcher).startLongpolling()
    
    ///Webhooks updates (need to addition setup), longpolling and webhooks cannot work simultaneously
        try Updater(bot: bot, dispatcher: dispatcher).startWebhooks().wait()
} catch {
    print(error.localizedDescription)
}
