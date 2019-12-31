//
//  CommandHandler.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 21.04.2018.
//

import AsyncHTTPClient

/**
 Handler class to handle Telegram commands.
 
 Commands are Telegram messages that start with /, optionally followed by an @ and the bot’s name
 and/or some additional text.
 
 - Options of this handler
 - `editedUpdates` Determines whether the handler should also accept edited messages.
 
 */
public class CommandHandler: Handler {
    public var name: String

    public struct Options: OptionSet {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        /// Determines Whether the handler should also accept edited messages. Not used by default.
        public static let editedUpdates = Options(rawValue: 1)
    }

    let commands: Set<String>
    let callback: HandlerCallback
    let filters: Filters
    let options: Options

    public init(
        name: String = String(describing: CommandHandler.self),
        commands: [String],
        filters: Filters = .all,
        options: Options = [],
        callback: @escaping HandlerCallback
        ) {
        self.name = name
        self.commands = Set(commands)
        self.filters = filters
        self.options = options
        self.callback = callback
    }

    public func check(update: Update) -> Bool {
        if options.contains(.editedUpdates),
            update.editedMessage != nil ||
                update.editedChannelPost != nil {
            return true
        }

        guard let message = update.message,
            filters.check(message),
            let text = message.text,
            let entities = message.entities else { return false }

        let types = entities.compactMap { (entity) -> String? in
            let start = text.index(text.startIndex, offsetBy: entity.offset)
            let end = text.index(start, offsetBy: entity.length-1)
            return String(text[start...end])
        }
        return !commands.intersection(types).isEmpty
    }

    public func handle(update: Update, dispatcher: Dispatcher) {
        do {
            try callback(update, nil)
        } catch {
            log.error(error.logMessage)
        }
    }
}
