//
//  VideoFilter.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

public struct VideoFilter: Filter {
    
    public var name: String = "video"
    
    public func filter(message: Message) -> Bool {
        return message.video != nil
    }
}

public extension Filters {
    static var video = Filters(filter: VideoFilter())
}
