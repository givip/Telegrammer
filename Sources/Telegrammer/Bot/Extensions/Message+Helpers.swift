//
//  Message+Helpers.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 09/06/2018.
//

public extension Message {
    func reply(_ text: String, from bot: Bot) throws {
        let params = Bot.SendMessageParams(chatId: .chat(chat.id), text: text)
        try bot.sendMessage(params: params)
    }
}
