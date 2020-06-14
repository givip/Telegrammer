//
//  AllFilter.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

/// Filter for any update, said "no filter"
public struct AllFilter: Filter {
    public var name: String = "all"

    public func filter(message: Message) -> Bool {
        return true
    }
}

public extension Filters {
    static var all = Filters(filter: AllFilter())
}
