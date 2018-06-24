//
//  VenueFilter.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

/// Messages that contain `Vanue`
public struct VenueFilter: Filter {
    
    public var name: String = "venue"
    
    public func filter(message: Message) -> Bool {
        return message.venue != nil
    }
}

public extension Filters {
    static var venue = Filters(filter: VenueFilter())
}
