//
//  RegexpHandler.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 11/06/2018.
//

import Foundation

public class RegexpHandler: Handler {
    public var name: String

    let regexp: NSRegularExpression
    let callback: HandlerCallback
    let filters: Filters

    public init(
        name: String = String(describing: RegexpHandler.self),
        regexp: NSRegularExpression,
        filters: Filters = .all,
        callback: @escaping HandlerCallback
        ) {
        self.name = name
        self.regexp = regexp
        self.filters = filters
        self.callback = callback
    }

    public convenience init?(
        name: String = String(describing: RegexpHandler.self),
        pattern: String,
        filters: Filters = .all,
        callback: @escaping HandlerCallback
        ) {
        guard let regexp = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        self.init(
            name: name,
            regexp: regexp,
            filters: filters,
            callback: callback
        )
    }

    public func check(update: Update) -> Bool {
        guard let text = update.message?.text else { return false }
        let range = NSRange(location: 0, length: text.count)
        return regexp.numberOfMatches(in: text, options: [], range: range) > 0
    }

    public func handle(update: Update, dispatcher: Dispatcher) {
        do {
            try callback(update, nil)
        } catch {
            log.error(error.logMessage)
        }
    }
}
