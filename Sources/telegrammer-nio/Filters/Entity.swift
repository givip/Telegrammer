//
//  Entity.swift
//  telegrammer-nio
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

public struct EntityFilter: Filter {
    public var name: String = "entity"
    
    public func filter(message: Message) -> Bool {
        //TODO: Implement
        return false
    }
}

public extension Filters {
    static var entity = Filters(filter: EntityFilter())
}
