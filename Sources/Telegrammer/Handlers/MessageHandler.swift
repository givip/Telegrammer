//
//  MessageHandler.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 21.04.2018.
//

import HTTP

public class MessageHandler: Handler {
	
	public var name: String
	
    let filters: Filters
    let callback: HandlerCallback
    let messageUpdates: Bool
    let channelPostUpdates: Bool
    let editedUpdates: Bool
	
	public init(
		filters: Filters = Filters.all,
		callback: @escaping HandlerCallback,
		messageUpdates: Bool = true,
		channelPostUpdates: Bool = true,
		editedUpdates: Bool = false,
		name: String = String(describing: MessageHandler.self)
		) {
        self.filters = filters
        self.callback = callback
        self.messageUpdates = messageUpdates
        self.channelPostUpdates = channelPostUpdates
        self.editedUpdates = editedUpdates
		self.name = name
    }
    
    public func check(update: Update) -> Bool {
        if channelPostUpdates {
            if update.channelPost != nil {
                return true
            }
            if editedUpdates,
                update.editedChannelPost != nil ||
                update.editedMessage != nil {
                return true
            }
        }
        
        if messageUpdates,
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
