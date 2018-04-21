//
//  PrivateFilter.swift
//  telegrammer-nio
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

public struct PrivateFilter: Filter {
    
    public var name: String = "private"
    
    public func filter(message: Message) -> Bool {
        return message.chat.type == .private
    }
}

public extension Filters {
    static var `private` = Filters(filter: PrivateFilter())
}
