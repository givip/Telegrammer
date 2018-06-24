//
//  GameFilter.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

/// Messages that contain `Game`
public struct GameFilter: Filter {
    
    public var name: String = "forwarded"
    
    public func filter(message: Message) -> Bool {
        return message.game != nil
    }
}

public extension Filters {
    static var game = Filters(filter: GameFilter())
}
