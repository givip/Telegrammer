//
//  ReplyFilter.swift
//  telegrammer-nio
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

public struct ReplyFilter: Filter {
    
    public var name: String = "reply"
    
    public func filter(message: Message) -> Bool {
        return message.replyToMessage != nil
    }
}

public extension Filters {
    static var reply = Filters(filter: ReplyFilter())
}
