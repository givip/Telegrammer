//
//  EntityFilterTest.swift
//  TelegrammerTests
//
//  Created by Givi on 01.01.2020.
//

import XCTest
@testable import Telegrammer

class EntityFilterTest: XCTestCase {

    var message: Message!
    var chat: Chat!

    override func setUp() {
        chat = Chat(id: 0, type: .private)
        message = Message(messageId: 0, date: 123, chat: chat)
    }

    override func tearDown() {
        chat = nil
        message = nil
    }

    func testNilEntities() {
        let entityFilter = EntityFilter(types: [])
        let result = entityFilter.filter(message: message)
        XCTAssertFalse(result)
    }

    func testEmptyEntities() {
        message.entities = []
        let entityFilter = EntityFilter(types: [])
        let result = entityFilter.filter(message: message)
        XCTAssertFalse(result)
    }

    func testNotIntersectableEntities() {
        let entityEmail = MessageEntity(type: .email, offset: 0, length: 10)
        let entityBold = MessageEntity(type: .bold, offset: 11, length: 15)
        message.entities = [entityEmail, entityBold]

        let entityFilter = EntityFilter(types: [.code, .botCommand])
        let result = entityFilter.filter(message: message)
        XCTAssertFalse(result)
    }

    func testIntersectableEntities() {
        let entityEmail = MessageEntity(type: .email, offset: 0, length: 10)
        let entityBold = MessageEntity(type: .bold, offset: 11, length: 10)
        message.entities = [entityEmail, entityBold]

        let entityFilter = EntityFilter(types: [.bold])
        let result = entityFilter.filter(message: message)
        XCTAssertTrue(result)
    }
}
