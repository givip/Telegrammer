//
//  GroupFilter.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

/// Messages sent in a group chat
public struct GroupFilter: Filter {

    public var name: String = "group"

    public func filter(message: Message) -> Bool {
        return message.chat.type != .private
    }
}

public extension Filters {
    static var group = Filters(filter: GroupFilter())
}
