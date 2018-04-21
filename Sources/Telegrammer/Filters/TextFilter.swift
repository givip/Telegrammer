//
//  TextFilter.swift
//  telegrammer-nio
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

public struct TextFilter: Filter {
    
    public var name: String = "text"
    
    public func filter(message: Message) -> Bool {
        guard let text = message.text else { return false }
        return !text.isEmpty
    }
}

public extension Filters {
    static var text = Filters(filter: TextFilter())
}
