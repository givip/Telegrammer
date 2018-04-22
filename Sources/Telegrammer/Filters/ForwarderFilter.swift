//
//  ForwarderFilter.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

public struct ForwarderFilter: Filter {
    
    public var name: String = "forwarded"
    
    public func filter(message: Message) -> Bool {
        return message.forwardDate != nil ||
        message.forwardFrom != nil ||
        message.forwardFromChat != nil ||
        message.forwardSignature != nil ||
        message.forwardFromMessageId != nil
    }
}

public extension Filters {
    static var forwarded = Filters(filter: ForwarderFilter())
}
