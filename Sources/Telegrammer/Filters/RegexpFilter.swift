//
//  RegexpFilter.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

public struct RegexpFilter: Filter {
    
    public var name: String = "regexp"
    
    public func filter(message: Message) -> Bool {
        //TODO: Implement
        return false
    }
}

public extension Filters {
    static var regexp = Filters(filter: RegexpFilter())
}
