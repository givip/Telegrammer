//
//  ChatFilter.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

public struct ChatFilter: Filter {
    
    var chatId: Int64
    var username: String?
    
    public init(chatId: Int64, username: String? = nil) {
        self.chatId = chatId
        self.username = username
    }
    
    public var name: String = "chat"
    
    public func filter(message: Message) -> Bool {
        guard message.chat.id == chatId else { return false }
        guard let desiredUsername = username else { return true }
        guard let incomingUsername = message.chat.username else { return true }
        return desiredUsername == incomingUsername
    }
}

public extension Filters {
    static func chat(chatId: Int64, username: String? = nil) -> Filters {
        return Filters(filter: ChatFilter(chatId: chatId, username: username))
    }
}
