//
//  PollAnswerHandler.swift
//  
//
//  Created by CaptainYukinoshitaHachiman on 2/2/20.
//

import HTTP

/// Handler for Poll Answers
public class PollAnswerHandler: Handler {
    
    public var name: String
    
    let callback: HandlerCallback
    
    public init(
        name: String = String(describing: CommandHandler.self),
        callback: @escaping HandlerCallback
        ) {
        self.name = name
        self.callback = callback
    }
    
    public func check(update: Update) -> Bool {
        return update.pollAnswer != nil
    }
    
    public func handle(update: Update, dispatcher: Dispatcher) throws {
        try callback(update, nil)
    }
    
}
