//
//  LocationFilter.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

public struct LocationFilter: Filter {
    
    public var name: String = "location"
    
    public func filter(message: Message) -> Bool {
        return message.location != nil
    }
}

public extension Filters {
    static var location = Filters(filter: LocationFilter())
}
