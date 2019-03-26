import Foundation
import Telegrammer


///Getting token from enviroment variable (most safe, recommended)
guard let token = Enviroment.get("TELEGRAM_BOT_TOKEN") else {
    print("TELEGRAM_BOT_TOKEN variable wasn't found in enviroment variables")
    exit(1)
}

do {
    let bot = try Bot(token: token)
    
    let dispatcher = Dispatcher(bot: bot)
    let controller = SpellCheckerController(bot: bot)
    
    let commandHandler = CommandHandler(commands: ["/start"], callback: controller.start)
    dispatcher.add(handler: commandHandler)
    
    let textHandler = MessageHandler(filters: .private, callback: controller.spellCheck)
    dispatcher.add(handler: textHandler)
    
    let inlineHandler = CallbackQueryHandler(pattern: "\\w+", callback: controller.inline)
    dispatcher.add(handler: inlineHandler)
    
    ///Longpolling updates
    _ = try Updater(bot: bot, dispatcher: dispatcher).startLongpolling().wait()
    
} catch {
    print(error.localizedDescription)
}
