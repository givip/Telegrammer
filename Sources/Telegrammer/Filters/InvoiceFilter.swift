//
//  InvoiceFilter.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

public struct InvoiceFilter: Filter {
    
    public var name: String = "invoice"
    
    public func filter(message: Message) -> Bool {
        return message.invoice != nil
    }
}

public extension Filters {
    static var invoice = Filters(filter: InvoiceFilter())
}
