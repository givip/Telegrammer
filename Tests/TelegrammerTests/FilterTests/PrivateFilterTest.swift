//
//  PrivateFilterTest.swift
//  TelegrammerTests
//
//  Created by Givi on 01.01.2020.
//

import XCTest
@testable import Telegrammer

class PrivateFilterTest: XCTestCase {

    func testPrivateChat() {
        let chat = Chat(id: 0, type: .private)
        let message = Message(messageId: 0, date: 123, chat: chat)

        let privateFilter = PrivateFilter()
        let result = privateFilter.filter(message: message)
        XCTAssertTrue(result)
    }

    func testPublicChat() {
        let chat = Chat(id: 0, type: .channel)
        let message = Message(messageId: 0, date: 123, chat: chat)

        let privateFilter = PrivateFilter()
        let result = privateFilter.filter(message: message)
        XCTAssertFalse(result)
    }

}
