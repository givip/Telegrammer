//
//  InputMedia.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 10.04.2018.
//

import Foundation

/// This enum represents the content of a media message to be sent.
public enum InputMedia: Encodable {
    case inputMediaPhoto(InputMediaPhoto)
    case inputMediaVideo(InputMediaVideo)
    case inputMediaAnimation(InputMediaAnimation)
    case inputMediaAudio(InputMediaAudio)
    case inputMediaDocument(InputMediaDocument)

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .inputMediaPhoto(let value):
            try container.encode(value)
        case .inputMediaVideo(let value):
            try container.encode(value)
        case .inputMediaAnimation(let value):
            try container.encode(value)
        case .inputMediaAudio(let value):
            try container.encode(value)
        case .inputMediaDocument(let value):
            try container.encode(value)
        }
    }
}

public enum InputMediaPhotoAndVideo: Encodable {
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
