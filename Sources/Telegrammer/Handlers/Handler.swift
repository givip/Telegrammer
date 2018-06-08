//
//  Handler.swift
//  Async
//
//  Created by Givi Pataridze on 21.04.2018.
//

import HTTP

public protocol BotContext { }

public typealias HandlerCallback = (_ update: Update, _ context: BotContext?) throws -> Void

public protocol Handler {
	var name: String { get }
	
    func check(update: Update) -> Bool
    func handle(update: Update, dispatcher: Dispatcher) throws
}



public protocol ErrorHandler: Handler { }
