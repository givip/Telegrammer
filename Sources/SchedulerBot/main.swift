
import Foundation
import NIO
import Telegrammer

///Getting token from enviroment variable (most safe, recommended)
guard let token = Enviroment.get("TELEGRAM_BOT_TOKEN") else {
    print("TELEGRAM_BOT_TOKEN variable wasn't found in enviroment variables")
    exit(1)
}

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

func onceTimerStart(_ update: Update, _ context: BotContext?) throws {
    guard let message = update.message else { return }

    var interval: TimeInterval = 5.0

    if let value = message.text?.split(separator: " ").last, let amount = Double(value) {
        interval = amount
    }

    let oneTimerJob = OnceJob(when: Date().addingTimeInterval(interval), context: message.chat) { chat in
        guard let chat = chat else { return }
        let params = Bot.SendMessageParams(chatId: .chat(chat.id), text: "Once, after \(interval) seconds: \(Date())")
        try bot.sendMessage(params: params)
    }

    _ = try jobQueue.scheduleOnce(oneTimerJob)
}

func repeatedTimerStart(_ update: Update, _ context: BotContext?) throws {
    guard let message = update.message,
        let user = message.from else { return }

    var interval = TimeAmount.seconds(5)

    if let value = message.text?.split(separator: " ").last, let amount = Int(value) {
        interval = TimeAmount.seconds(amount)
    }

    let secondsInterval = interval.nanoseconds / 1_000_000_000

    if userJobs[user.id] == nil {
        let timerJob = RepeatableJob(when: Date(), interval: interval, context: message.chat) { chat in
            guard let chat = chat else { return }
            let params = Bot.SendMessageParams(chatId: .chat(chat.id), text: "Repeating each \(secondsInterval) seconds: \(Date())")
            try bot.sendMessage(params: params)
        }

        userJobs[user.id] = timerJob.id

        _ = jobQueue.scheduleRepeated(timerJob)
    }
}

func repeatedTimerStop(_ update: Update, _ context: BotContext?) throws {
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

    let onceTimerStartHandler = CommandHandler(commands: ["/once"], callback: onceTimerStart)
    dispatcher.add(handler: onceTimerStartHandler)

    let repeatedTimerStartHandler = CommandHandler(commands: ["/start"], callback: repeatedTimerStart)
    dispatcher.add(handler: repeatedTimerStartHandler)

    let repeatedTimerStopHandler = CommandHandler(commands: ["/stop"], callback: repeatedTimerStop)
    dispatcher.add(handler: repeatedTimerStopHandler)

    ///Longpolling updates
    _ = try Updater(bot: bot, dispatcher: dispatcher).startLongpolling().wait()

} catch {
    print(error.localizedDescription)
}
