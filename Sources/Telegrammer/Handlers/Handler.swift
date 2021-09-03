//
//  Handler.swift
//  Async
//
//  Created by Givi Pataridze on 21.04.2018.
//

import AsyncHTTPClient

public protocol BotContext { }

#if compiler(>=5.5)
public typealias HandlerCallback = (_ update: Update, _ context: BotContext?) async throws -> Void
#else
public typealias HandlerCallback = (_ update: Update, _ context: BotContext?) throws -> Void
#endif

/**
 Protocol for any update handler
 
 Every handler must implement `check` and `handle` methods
 */
public protocol Handler: AutoMockable {
    var name: String { get }

    func check(update: Update) -> Bool
    
    #if compiler(>=5.5)
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    func handle(update: Update, dispatcher: Dispatcher) async
    #else
    func handle(update: Update, dispatcher: Dispatcher)
    #endif
}

extension Handler {
    public var name: String {
        return String(describing: Self.self)
    }
}
