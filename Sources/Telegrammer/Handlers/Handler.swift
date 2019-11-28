//
//  Handler.swift
//  Async
//
//  Created by Givi Pataridze on 21.04.2018.
//

import AsyncHTTPClient

public protocol BotContext { }

public typealias HandlerCallback = (_ update: Update, _ context: BotContext?) throws -> Void

/**
 Protocol for any update handler
 
 Every handler must implement `check` and `handle` methods
 */
public protocol Handler {
    var name: String { get }
    
    func check(update: Update) -> Bool
    func handle(update: Update, dispatcher: Dispatcher)
}

extension Handler {
    public var name: String {
        return String(describing: Self.self)
    }
}

public protocol ErrorHandler: Handler { }
