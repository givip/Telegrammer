//
//  Error+Helpers.swift
//  Telegrammer
//
//  Created by Givi on 19/03/2019.
//

import Foundation
import Logging_swift

public extension Error {
    var logMessage: Logger.Message {
        return Logger.Message(stringLiteral: self.localizedDescription)
    }
}
