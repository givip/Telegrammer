//
//  SpellCheckerController.swift
//  SpellCheckerBot
//
//  Created by Givi Pataridze on 16/06/2018.
//

import Foundation
import Telegrammer

class SpellCheckerController {
    
    var sessions: [Int64: YaSpellFlow] = [:]
    let spellChecker = YaSpellChecker()
    var cache: [String: String] = [:]
    let bot: Bot
    
    let attentionText =
    """
    📌 Attention!
    📩 Please send text WITHOUT emoji, hashtags and invisible symbols, otherwise Yndex.Speller check will be incorrect.
    """
    
    init(bot: Bot) {
        self.bot = bot
    }
    
    private func menu(_ buttons: [String]) -> InlineKeyboardMarkup {
        var menuButtons = buttons.map({ (spell) -> InlineKeyboardButton in
            let key = UUID().uuidString
            self.cache[key] = spell
            return InlineKeyboardButton(text: spell, callbackData: "fix:\(key)")
        }).chunk(3)
        
        menuButtons.append([ InlineKeyboardButton(text: "⁉️ Fix this word later", callbackData: "skip") ])
        menuButtons.append([ InlineKeyboardButton(text: "❎ This is correct", callbackData: "keep") ])
        menuButtons.append([ InlineKeyboardButton(text: "🚀 Entire fixed text", callbackData: "finish") ])
        menuButtons.append([ InlineKeyboardButton(text: "⚠️ Cancel spellcheck", callbackData: "cancel") ])
        
        return InlineKeyboardMarkup(inlineKeyboard: menuButtons)
    }
    
    func start(_ update: Update, _ context: BotContext?) throws {
        guard let message = update.message else { return }
        try respond(to: message, text: "Send text to bot, you want to spellcheck ✅\n\n\(attentionText)")
    }
    
    func spellCheck(_ update: Update, _ context: BotContext?) throws {
        guard let message = update.message,
            let text = message.text,
            let user = message.from else { return }
        
        spellChecker.check(text, lang: .en, format: .plain) { [unowned self] (checks) in
            guard !checks.isEmpty else {
                try self.congrat(message: message)
                return
            }
            
            let flow = YaSpellFlow()
            flow.start(text, checks: checks)
            
            self.sessions[user.id] = flow
            
            try self.begin(flow, to: message)
        }
    }
    
    func inline(_ update: Update, _ context: BotContext?) throws {
        guard let query = update.callbackQuery,
            let message = query.message,
            let data = query.data else { return }
        
        let user = query.from
        let parts = data.split(separator: ":")
        
        guard let flow = sessions[user.id],
            let first = parts.first,
            let command = Command(rawValue: "\(first)") else { return }
        
        switch command {
        case .keep:
            flow.keep()
            try next(flow, to: message)
        case .skip:
            flow.skip()
            try next(flow, to: message)
        case .fix:
            guard let last = parts.last, let fixData = cache["\(last)"] else { return }
            cache.removeValue(forKey: "\(last)")
            flow.fix(fixData)
            try next(flow, to: message)
        case .finish:
            try finish(flow, to: message)
        case .cancel:
            sessions.removeValue(forKey: user.id)
            try cancel(message: message)
        }
    }
}

private extension SpellCheckerController {
    
    func commentedChunk(_ chunk: String) -> String {
        return "\(attentionText)\n\n*Fix mistake:*\n\n\(chunk)"
    }
    
    func begin(_ flow: YaSpellFlow, to message: Message) throws {
        guard let result: (textChunk: String, spellFixes:[String]) = flow.next() else { return }
        let markup = menu(result.spellFixes)
        try self.respond(to: message, text: commentedChunk(result.textChunk), markup: .inlineKeyboardMarkup(markup))
    }
    
    func next(_ flow: YaSpellFlow, to message: Message) throws {
        if let result: (textChunk: String, spellFixes:[String]) = flow.next() {
            let markup = menu(result.spellFixes)
            try edit(message: message, text: commentedChunk(result.textChunk), markup: markup)
        } else {
            try finish(flow, to: message)
        }
    }
    
    func finish(_ flow: YaSpellFlow, to message: Message) throws {
        let correctedText = flow.finish()
        try edit(message: message, text: "✅ Fixed text:")
        try respond(to: message, text: "```\n\(correctedText)\n```")
    }
    
    func congrat(message: Message) throws {
        try message.reply(text: "👏 Congratulate! Your text is without any mistakes!", from: bot)
    }
    
    func cancel(message: Message) throws {
        try edit(message: message, text: "😔 You canceled spellcheck.")
    }
}

private extension SpellCheckerController {
    
    func edit(message: Message, text: String, markup: InlineKeyboardMarkup? = nil) throws {
        let params = Bot.EditMessageTextParams(chatId: .chat(message.chat.id),
                                               messageId: message.messageId,
                                               text: text,
                                               parseMode: .markdown,
                                               replyMarkup: markup)
        try bot.editMessageText(params: params)
    }
    
    func respond(to message: Message, text: String, markup: ReplyMarkup? = nil) throws {
        let params = Bot.SendMessageParams(chatId: .chat(message.chat.id),
                                           text: text,
                                           parseMode: .markdown,
                                           replyMarkup: markup)
        try self.bot.sendMessage(params: params)
    }
    
    func delete(message: Message) throws {
        let params = Bot.DeleteMessageParams(chatId: .chat(message.chat.id), messageId: message.messageId)
        try self.bot.deleteMessage(params: params)
    }
}
