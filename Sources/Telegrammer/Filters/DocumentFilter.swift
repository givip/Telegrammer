//
//  DocumentFilter.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

public struct DocumentFilter: Filter {
    
    public var name: String = "document"
    
    public func filter(message: Message) -> Bool {
        return message.document != nil
    }
}

public extension Filters {
    static var document = Filters(filter: DocumentFilter())
}
