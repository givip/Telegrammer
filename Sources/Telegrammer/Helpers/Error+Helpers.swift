//
//  Error+Helpers.swift
//  Telegrammer
//
//  Created by Givi on 19/03/2019.
//

import Foundation
import Logging

public extension Error {
    var logMessage: Logger.Message {
        var errorDescription: String
        if let coreError = self as? CoreError {
            errorDescription = coreError.localizedDescription
        } else if let decodingError = self as? DecodingError {
            switch decodingError {
                case .dataCorrupted(let context):
                    errorDescription = context.debugDescription
                case .keyNotFound(_, let context):
                    errorDescription = context.debugDescription
                case .typeMismatch(_, let context):
                    errorDescription = context.debugDescription
                case .valueNotFound(_, let context):
                    errorDescription = context.debugDescription
                @unknown default:
                    errorDescription = "Uknown DecodingError"
            }
        } else {
            errorDescription = "Cannot detect error type, providing default description:\n\(self.localizedDescription)"
        }
        return Logger.Message(stringLiteral: errorDescription)
    }
}
