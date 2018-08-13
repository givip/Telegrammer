//
//  InputMessageContent.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 10.04.2018.
//

import Foundation

/// This object represents the content of a message to be sent as a result of an inline query. Telegram clients currently support the following 4 types
public enum InputMessageContent: Codable {
    case inputTextMessageContent(InputTextMessageContent)
    case inputLocationMessageContent(InputLocationMessageContent)
    case inputVenueMessageContent(InputVenueMessageContent)
    case inputContactMessageContent(InputContactMessageContent)
    case undefined
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .inputTextMessageContent(let value):
            try container.encode(value)
        case .inputLocationMessageContent(let value):
            try container.encode(value)
        case .inputVenueMessageContent(let value):
            try container.encode(value)
        case .inputContactMessageContent(let value):
            try container.encode(value)
        case .undefined:
            try container.encodeNil()
        }
    }
    public init(from decoder: Decoder) throws {
        if let value = try? decoder.singleValueContainer().decode(InputTextMessageContent.self) {
            self = .inputTextMessageContent(value)
            return
        }
        if let value = try? decoder.singleValueContainer().decode(InputLocationMessageContent.self) {
            self = .inputLocationMessageContent(value)
            return
        }
        if let value = try? decoder.singleValueContainer().decode(InputVenueMessageContent.self) {
            self = .inputVenueMessageContent(value)
            return
        }
        if let value = try? decoder.singleValueContainer().decode(InputContactMessageContent.self) {
            self = .inputContactMessageContent(value)
            return
        }
        self = .undefined
    }
}
