//
//  MessageEntityType.swift
//  telegrammer-nio
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

/// Type of the entity.
///
/// - mention: @username
/// - hashtag: hashtag
/// - botCommand: botCommand
/// - url: url
/// - email: email
/// - bold: bold text
/// - italic: italic text
/// - code: monowidth string
/// - pre: monowidth block
/// - text_link: for clickable text URLs
/// - text_mention: for users without usernames
///
/// [- SeeAlso: ]<https://core.telegram.org/bots/api#messageentity>

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
}
