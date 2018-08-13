//
//  MessageEntityType.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

/// Type of the entity. Can be mention (@username), hashtag, bot_command, url, email, bold (bold text), italic (italic text), code (monowidth string), pre (monowidth block), text_link (for clickable text URLs), text_mention (for users without usernames)
public enum MessageEntityType: String, Codable {
    case mention     = "mention"
    case hashtag     = "hashtag"
    case botCommand  = "bot_command"
    case url         = "url"
    case email       = "email"
    case bold        = "bold"
    case italic      = "italic"
    case code        = "code"
    case pre         = "pre"
    case textLink    = "text_link"
    case textMention = "text_mention"
    case phoneNumber = "phone_number"
    case cashtag     = "cashtag"
    case undefined
    
    public init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        guard let type = MessageEntityType(rawValue: value) else {
            self = .undefined
            return
        }
        self = type
    }
}
