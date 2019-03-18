
import Foundation
import Telegrammer

///Getting token from enviroment variable (most safe, recommended)
guard let token = Enviroment.get("TELEGRAM_BOT_TOKEN") else { exit(1) }

/// Initializind Bot settings (token, debugmode)
var settings = Bot.Settings(token: token)

///Webhooks settings
//settings.webhooksIp = Enviroment.get("TELEGRAM_BOT_IP")!
//settings.webhooksUrl = Enviroment.get("TELEGRAM_BOT_WEBHOOK_URL")!
//settings.webhooksPort = Int(Enviroment.get("TELEGRAM_BOT_PORT")!)!
//settings.webhooksPublicCert = Enviroment.get("TELEGRAM_BOT_PUBLIC_KEY")!

let bot = try! Bot(settings: settings)
let jobQueue = BasicJobQueue<Chat>(bot: bot)

/// Dictionary for user echo modes
var userJobs: [Int64: String] = [:]

///Callback for Command handler, which send Echo mode status for user
func timerEchoStart(_ update: Update, _ context: BotContext?) throws {
    guard let message = update.message,
        let user = message.from else { return }

    if userJobs[user.id] == nil {
        let timerJob = RepeatableJob(when: Date(), interval: .seconds(5), context: message.chat) { chat in
            guard let chat = chat else { return }
            let params = Bot.SendMessageParams(chatId: .chat(chat.id), text: "\(Date())")
            try bot.sendMessage(params: params)
        }

        userJobs[user.id] = timerJob.id

        _ = jobQueue.scheduleRepeated(timerJob)
    }
}

///Callback for Command handler, which send Echo mode status for user
func timerEchoStop(_ update: Update, _ context: BotContext?) throws {
    guard let message = update.message,
        let user = message.from else { return }

    if let scheduledJobId = userJobs[user.id] {
        if let notFinishedJob = jobQueue.jobs.first(where: { $0.id == scheduledJobId }) {
            notFinishedJob.scheduleRemoval()
        }

        userJobs.removeValue(forKey: user.id)
    }
}

do {
    ///Dispatcher - handle all incoming messages
    let dispatcher = Dispatcher(bot: bot)

    ///Creating and adding handler for command /echo
    let startHandler = CommandHandler(commands: ["/start"], callback: timerEchoStart)
    dispatcher.add(handler: startHandler)

    let stopHandler = CommandHandler(commands: ["/stop"], callback: timerEchoStop)
    dispatcher.add(handler: stopHandler)

    ///Longpolling updates
    _ = try Updater(bot: bot, dispatcher: dispatcher).startLongpolling().wait()

} catch {
    print(error.localizedDescription)
}
