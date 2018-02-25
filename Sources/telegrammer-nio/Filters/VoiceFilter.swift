//
//  VoiceFilter.swift
//  telegrammer-nio
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

public struct VoiceFilter: Filter {
    
    public var name: String = "voice"
    
    public func filter(message: Message) -> Bool {
        return message.voice != nil
    }
}

public extension Filters {
    static var voice = Filters(filter: VoiceFilter())
}
