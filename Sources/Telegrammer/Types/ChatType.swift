//
//  ChatType.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

/// Type of chat, can be either “private”, “group”, “supergroup” or “channel”
public enum ChatType: String, Codable {
    case `private`  = "private"
    case group      = "group"
    case supergroup = "supergroup"
    case channel    = "channel"
    case unknown
}
