//
//  SuccesfulPaymentFilter.swift
//  telegrammer-nio
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

public struct SuccesfulPaymentFilter: Filter {
    
    public var name: String = "successful_payment"
    
    public func filter(message: Message) -> Bool {
        return message.successfulPayment != nil
    }
}

public extension Filters {
    static var successfulPayment = Filters(filter: SuccesfulPaymentFilter())
}
