//
//  CommandHandler.swift
//  telegrammer-nio
//
//  Created by Givi Pataridze on 21.04.2018.
//

import HTTP

public class CommandHandler: Handler {

    let commands: Set<String>
    let callback: HandlerCallback 
    let filters: Filters
    let editedUpdates: Bool
    
    public init(commands: [String],
                filters: Filters = Filters.command,
                callback: @escaping HandlerCallback,
                editedUpdates: Bool = false) {
        self.commands = Set(commands)
        self.callback = callback
        self.filters = filters
        self.editedUpdates = editedUpdates
    }
    
    public func check(update: Update) -> Bool {
        if editedUpdates,
            update.editedMessage != nil ||
                update.editedChannelPost != nil {
            return true
        }
            
        guard let message = update.message else { return false }
        guard filters.check(message) else { return false }
        guard let text = message.text else { return false }
        return commands.contains { text.hasPrefix("/\($0)") } //FIXME: must handle /start_ not /startOther
    }
    
    public func handle(update: Update, dispatcher: Dispatcher) {
        callback(update, dispatcher.updateQueue, dispatcher.jobQueue)
    }
}
