//
//  CallbackQueryHandler.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 23.04.2018.
//

import Foundation

/// Handler for CallbackQuery updates
public class CallbackQueryHandler: Handler {
    
    public var name: String
    
    let pattern: String
    let callback: HandlerCallback
    
    public init(
        pattern: String,
        callback: @escaping HandlerCallback,
        name: String = String(describing: CallbackQueryHandler.self)
        ) {
        self.pattern = pattern
        self.callback = callback
        self.name = name
    }
    
    public func check(update: Update) -> Bool {
        guard let callbackQuery = update.callbackQuery else { return false }
        if let data = callbackQuery.data,
            !data.matchRegexp(pattern: pattern) {
            return false
        }
        return true
    }
    
    public func handle(update: Update, dispatcher: Dispatcher) {
        do {
            try callback(update, nil)
        } catch {
            log.error(error.logMessage)
        }
    }
}
