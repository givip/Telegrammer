//
//  LanguageFilter.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

public struct LanguageFilter: Filter {
    
    public var name: String = "language"
    
    public func filter(message: Message) -> Bool {
        //TODO: Implement
        return false
    }
}

public extension Filters {
    static var language = Filters(filter: LanguageFilter())
}
