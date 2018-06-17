//
//  CommandHandler.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 21.04.2018.
//

import HTTP

public class CommandHandler: Handler {
	public var name: String

    public struct Options: OptionSet {
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        ///Determines whether the handler should also accept edited messages.
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
            let nsRange = NSRange(location: entity.offset, length: entity.length)
            guard let range = Range(nsRange, in: text) else { return nil }
            return String(text[range])
        }
        return !commands.intersection(types).isEmpty
    }
    
    public func handle(update: Update, dispatcher: Dispatcher) throws {
        try callback(update, nil)
    }
}
