//
//  InputMedia.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 10.04.2018.
//

import Foundation

public enum InputMedia: Encodable {
    case inputMediaPhoto(InputMediaPhoto)
    case inputMediaVideo(InputMediaVideo)
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .inputMediaPhoto(let value):
            try container.encode(value)
        case .inputMediaVideo(let value):
            try container.encode(value)
        }
    }
}
