//
//  ConversationHandler.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 08.06.2018.
//

import Foundation
import NIO

public class ConversationHandler: Handler {

    public var name: String

    public struct Options: OptionSet {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        ///Determines if a user can restart a conversation with an entry point.
        public static let allowReentry = Options(rawValue: 1)
        ///If the conversationkey should contain the Chat’s ID.
        public static let perChat = Options(rawValue: 2)
        ///If the conversationkey should contain the User’s ID.
        public static let perUser = Options(rawValue: 4)
        ///If the conversationkey should contain the Message’s ID.
        public static let perMessage = Options(rawValue: 8)
    }

    public var entryPoints: [Handler] = []
    public var states: [String: [Handler]] = [:]
    public var fallbacks: [Handler] = []
    public var timeoutBehavior: [Handler] = []

    let options: Options
    let conversationTimeout: TimeAmount?
    let callback: HandlerCallback

    public init(
        name: String = String(describing: ConversationHandler.self),
        options: Options = [],
        conversationTimeout: TimeAmount? = nil,
        callback: @escaping HandlerCallback
        ) {
        self.name = name
        self.options = options
        self.conversationTimeout = conversationTimeout
        self.callback = callback
    }

    public func check(update: Update) -> Bool {
        return true
    }
    
    #if compiler(>=5.5)
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public func handle(update: Update, dispatcher: Dispatcher) async {
        do {
            try await callback(update, nil)
        } catch {
            log.error(error.logMessage)
        }
    }
    #else
    public func handle(update: Update, dispatcher: Dispatcher) {
        do {
            try callback(update, nil)
        } catch {
            log.error(error.logMessage)
        }
    }
    #endif
}
