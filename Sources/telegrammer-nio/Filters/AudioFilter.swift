//
//  AudioFilter.swift
//  telegrammer-nio
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

public struct AudioFilter: Filter {
    public var name: String = "audio"
    
    public func filter(message: Message) -> Bool {
        return message.audio != nil
    }
}

public extension Filters {
    static var audio = Filters(filter: AudioFilter())
}
