//
//  StickerFilter.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

public struct StickerFilter: Filter {
    
    public var name: String = "sticker"
    
    public func filter(message: Message) -> Bool {
        return message.sticker != nil
    }
}

public extension Filters {
    static var sticker = Filters(filter: StickerFilter())
}
