//
//  ReplyMarkup.swift
//  App
//
//  Created by Givi Pataridze on 01.03.2018.
//

import MultipartKit

/** Enum for InlineKeyboardMarkup or ReplyKeyboardMarkup or ReplyKeyboardRemove or ForceReply
 
 SeeAlso Telegram Bot API Reference:
 [Reply Markups](https://core.telegram.org/bots/2-0-intro#new-inline-keyboards)
 */
public enum ReplyMarkup: Codable, MultipartPartConvertible {
    case inlineKeyboardMarkup(InlineKeyboardMarkup)
    case replyKeyboardMarkup(ReplyKeyboardMarkup)
    case replyKeyboardRemove(ReplyKeyboardRemove)
    case forceReply(ForceReply)
    case undefined
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .inlineKeyboardMarkup(let value):
            try container.encode(value)
        case .replyKeyboardMarkup(let value):
            try container.encode(value)
        case .replyKeyboardRemove(let value):
            try container.encode(value)
        case .forceReply(let value):
            try container.encode(value)
        case .undefined:
            try container.encodeNil()
        }
    }
    
    public init(from decoder: Decoder) throws {
        if let value = try? decoder.singleValueContainer().decode(InlineKeyboardMarkup.self) {
            self = .inlineKeyboardMarkup(value)
            return
        }
        if let value = try? decoder.singleValueContainer().decode(ReplyKeyboardMarkup.self) {
            self = .replyKeyboardMarkup(value)
            return
        }
        if let value = try? decoder.singleValueContainer().decode(ReplyKeyboardRemove.self) {
            self = .replyKeyboardRemove(value)
            return
        }
        if let value = try? decoder.singleValueContainer().decode(ForceReply.self) {
            self = .forceReply(value)
            return
        }
        self = .undefined
    }
}
