//
//  MessageHandler.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 21.04.2018.
//

import AsyncHTTPClient

/// Handler for bot messages, can handle normal messages, channel posts, edited messages
public class MessageHandler: Handler {
    
    /// Name of particular MessageHandler, needed for determine handlers instances of one class in groups
    public var name: String
    
    /// Option Set for `MessageHandler`
    public struct Options: OptionSet {
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        ///Should “normal” message updates be handled?
        public static let messageUpdates = Options(rawValue: 1)
        ///Should channel posts updates be handled?
        public static let channelPostUpdates = Options(rawValue: 2)
        ///Should “edited” message updates be handled?
        public static let editedUpdates = Options(rawValue: 4)
    }
    
    let filters: Filters
    let callback: HandlerCallback
    let options: Options
    
    public init(
        name: String = String(describing: MessageHandler.self),
        filters: Filters = .all,
        options: Options = [.messageUpdates, .channelPostUpdates],
        callback: @escaping HandlerCallback
        ) {
        self.filters = filters
        self.callback = callback
        self.options = options
        self.name = name
    }
    
    public func check(update: Update) -> Bool {
        if options.contains(.channelPostUpdates) {
            if update.channelPost != nil {
                return true
            }
            if options.contains(.editedUpdates),
                update.editedChannelPost != nil ||
                    update.editedMessage != nil {
                return true
            }
        }
        
        if options.contains(.messageUpdates),
            let message = update.message,
            filters.check(message) {
            return true
        }
        
        return false
    }
    
    public func handle(update: Update, dispatcher: Dispatcher) throws {
        try callback(update, nil)
    }
}
