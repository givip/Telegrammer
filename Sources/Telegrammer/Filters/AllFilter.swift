//
//  AllFilter.swift
//  telegrammer-nio
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

public struct AllFilter: Filter {
    public var name: String = "all"
    
    public func filter(message: Message) -> Bool {
        return true
    }
}

public extension Filters {
    static var all = Filters(filter: AllFilter())    
}
