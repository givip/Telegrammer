//
//  EntityFilter.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

public struct EntityFilter: Filter {
    
    let entityType: MessageEntityType
    
    public init(entityType: MessageEntityType) {
        self.entityType = entityType
    }
    
    public var name: String = "entity"
    
    public func filter(message: Message) -> Bool {
        guard let entities = message.entities else { return false }
        return entities.contains(where: { $0.type == entityType })
    }
}

public extension Filters {
    static var entity = Filters(filter: EntityFilter())
}
