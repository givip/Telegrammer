//
//  Message+Helpers.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 09/06/2018.
//

public extension Message {
    func reply(text: String, from bot: Bot, parseMode: ParseMode? = nil, replyMarkup: ReplyMarkup? = nil) throws {
        let params = Bot.SendMessageParams(chatId: .chat(chat.id),
                                           text: text,
                                           parseMode: parseMode,
                                           replyMarkup: replyMarkup)
        try bot.sendMessage(params: params)
    }
    
    func edit(text: String, from bot: Bot, parseMode: ParseMode? = nil, replyMarkup: InlineKeyboardMarkup? = nil) throws {
        let params = Bot.EditMessageTextParams(chatId: .chat(chat.id),
                                               text: text,
                                               parseMode: parseMode,
                                               replyMarkup: replyMarkup)
        try bot.editMessageText(params: params)
    }
    
    func delete(from bot: Bot) throws {
        let params = Bot.DeleteMessageParams(chatId: .chat(chat.id), messageId: messageId)
        try bot.deleteMessage(params: params)
    }
}
