//
//  BotError
//  Telegrammer
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation
import Logging

public class BotError: Error {}

public class CoreError: Error {
    public enum `Type` {
        case `internal`
        case network
        case server
    }

    public let type: Type
    public let description: String
    public let reason: String

    public init(type: Type, description: String = "", reason: String = "") {
        self.type = type
        self.description = description
        self.reason = reason
    }

    public var localizedDescription: String {
        return """

        >>>Type: \(type)
        >>>Description: \(description)
        >>>Reason: \(reason)

        """
    }
}
//exception telegram.error.BadRequest(message)
//Bases: telegram.error.NetworkError
//
//exception telegram.error.ChatMigrated(new_chat_id)
//Bases: telegram.error.TelegramError
//
//Parameters:    new_chat_id (int) –
//exception telegram.error.InvalidToken
//Bases: telegram.error.TelegramError
//
//exception telegram.error.NetworkError(message)
//Bases: telegram.error.TelegramError
//
//exception telegram.error.RetryAfter(retry_after)
//Bases: telegram.error.TelegramError
//
//Parameters:    retry_after (int) –
//exception telegram.error.TelegramError(message)
//Bases: Exception
//
//exception telegram.error.TimedOut
//Bases: telegram.error.NetworkError
//
//exception telegram.error.Unauthorized(message)
//Bases: telegram.error.TelegramError
