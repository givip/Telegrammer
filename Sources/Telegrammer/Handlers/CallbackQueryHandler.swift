//
//  CallbackQueryHandler.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 23.04.2018.
//

import Foundation

public class CallbackQueryHandler: Handler {
    
    let pattern: String
    let callback: HandlerCallback
    
    public init(pattern: String,
                callback: @escaping HandlerCallback) {
        self.pattern = pattern
        self.callback = callback
    }
    
    public func check(update: Update) -> Bool {
        guard let callbackQuery = update.callbackQuery else { return false }
        if let data = callbackQuery.data,
            !data.matchRegexp(pattern: pattern) {
            return false
        }
        return true
    }
    
    public func handle(update: Update, dispatcher: Dispatcher) throws {
        try callback(update, dispatcher.updateQueue, dispatcher.jobQueue)
    }
}
