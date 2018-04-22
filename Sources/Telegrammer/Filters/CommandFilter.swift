//
//  CommandFilter.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

public struct CommandFilter: Filter {

    public var name: String = "command"
    
    public func filter(message: Message) -> Bool {
        guard let text = message.text else { return false }
        return text.starts(with: "/")
    }
}

public extension Filters {
    static var command = Filters(filter: CommandFilter())   
}
