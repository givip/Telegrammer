//
//  InputMessageContent.swift
//  telegrammer-nio
//
//  Created by Givi Pataridze on 10.04.2018.
//

import Foundation

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
            self = InputMessageContent.inputTextMessageContent(value)
            return
        }
        if let value = try? decoder.singleValueContainer().decode(InputLocationMessageContent.self) {
            self = InputMessageContent.inputLocationMessageContent(value)
            return
        }
        if let value = try? decoder.singleValueContainer().decode(InputVenueMessageContent.self) {
            self = InputMessageContent.inputVenueMessageContent(value)
            return
        }
        if let value = try? decoder.singleValueContainer().decode(InputContactMessageContent.self) {
            self = InputMessageContent.inputContactMessageContent(value)
            return
        }
        self = InputMessageContent.undefined
    }
}
