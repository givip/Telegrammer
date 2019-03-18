//
//  Test+Helpers.swift
//  TelegrammerTests
//
//  Created by Givi on 18/03/2019.
//

import XCTest

extension Date {
    func isCloseTo(_ date: Date, accuracy: Double) -> Bool {
        return abs(self.timeIntervalSince(date)) < accuracy
    }
}
