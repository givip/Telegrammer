//
//  ContactFilter.swift
//  telegrammer-nio
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

public struct ContactFilter: Filter {
    
    public var name: String = "contact"
    
    public func filter(message: Message) -> Bool {
        return message.contact != nil
    }
}

public extension Filters {
    static var contact = Filters(filter: ContactFilter())
}
