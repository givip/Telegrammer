//
//  CaptionEntity.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 24/06/2018.
//

import Foundation

/// Filters media messages to only allow those which have a `MessageEntity` where their type matches `type`.
public struct CaptionEntityFilter: Filter {

    var entityType: MessageEntityType

    public init(type: MessageEntityType) {
        self.entityType = type
    }

    public var name: String = "caption_entity"

    public func filter(message: Message) -> Bool {
        guard let entities = message.entities else { return false }
        return entities.contains(where: { (entity) -> Bool in
            return entity.type == entityType
        })
    }
}

public extension Filters {
    static func captionEntity(type: MessageEntityType) -> Filters {
        return Filters(filter: CaptionEntityFilter(type: type))
    }
}
