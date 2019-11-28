//
//  LoggerHandler.swift
//  
//
//  Created by Givi on 27.11.2019.
//

import Foundation
import Logging

public class LoggerHandler: Handler {
    let logLevel: Logger.Level

    public init(level: Logger.Level) {
        self.logLevel = level
    }

    public func check(update: Update) -> Bool {
        return true
    }

    public func handle(update: Update, dispatcher: Dispatcher) {
        log.log(level: logLevel, update.logMessage)
    }
}

extension Update {
    var description: String {
        //TODO: Improve description algorithm, serialization/deserialization too heavy
        var resultString = "[]"

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(self)
            if let json = String(data: data, encoding: .utf8) {
                resultString = json
            }
        } catch {
            log.error(error.logMessage)
        }
        return resultString
    }

    var logMessage: Logger.Message {
        return Logger.Message(stringLiteral: description)
    }
}

extension Array where Element: Update {
    var description: String {
        var str: String = ""
        self.forEach { (elem) in
            str.append(elem.description)
            str.append("\n")
        }
        return str
    }
}
