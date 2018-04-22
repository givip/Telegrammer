//
//  EntityFilter.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

public struct EntityFilter: Filter {
    
    let entityType: MessageEntityType
    
    public init(type: MessageEntityType) {
        self.entityType = type
    }
    
    public var name: String = "entity"
    
    public func filter(message: Message) -> Bool {
        guard let entities = message.entities else { return false }
        return entities.contains(where: { $0.type == entityType })
    }
}

public extension Filters {
    static func entity(type: MessageEntityType) -> Filters {
        return Filters(filter: EntityFilter(type: type))
    }
}
