//
//  CommandHandlerTest.swift
//  TelegrammerTests
//
//  Created by Givi on 01.01.2020.
//

import XCTest
@testable import Telegrammer

class CommandHandlerTest: XCTestCase {

    func createUpdateWithBotCommand(_ text: String, _ cmdOffset: Int, _ length: Int, _ edited: Bool) -> Update {
        let update = Update(updateId: 0)
        let chat = Chat(id: 0, type: .private)
        let message = Message(messageId: 0, date: 123, chat: chat)
        message.text = text
        let entity = MessageEntity(type: .botCommand, offset: cmdOffset, length: length)
        message.entities = [entity]
        if (edited) {
            update.editedMessage = message
        } else {
            update.message = message
        }
        return update
    }

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMessageWithMatchingCommand() {
        let update = createUpdateWithBotCommand("Blah /start blah", 5, 6, false)
        let handler = CommandHandler(commands: ["/start"]) { (_, _) in }
        XCTAssertTrue(handler.check(update: update))
    }

    func testMessageWithoutMatchingCommand() {
        let update = createUpdateWithBotCommand("/otherstart", 0, 11, false)
        let handler = CommandHandler(commands: ["/start"]) { (_, _) in }
        XCTAssertFalse(handler.check(update: update))
    }

    func testEditedMessageWithMatchingCommand() {
        let update = createUpdateWithBotCommand("Blah /start blah", 5, 6, true)
        let handlerForEdited = CommandHandler(commands: ["/start"], options: [.editedUpdates]) { (_, _) in }
        XCTAssertTrue(handlerForEdited.check(update: update))
        let handler = CommandHandler(commands: ["/start"]) { (_, _) in }
        XCTAssertFalse(handler.check(update: update))
    }

    func testEditedMessageWithoutMatchingCommand() {
        let update = createUpdateWithBotCommand("/otherstart", 0, 11, true)
        let handlerForEdited = CommandHandler(commands: ["/start"], options: [.editedUpdates]) { (_, _) in }
        XCTAssertFalse(handlerForEdited.check(update: update))
        let handler = CommandHandler(commands: ["/start"]) { (_, _) in }
        XCTAssertFalse(handler.check(update: update))
    }

    func testEditedMessageWthMixedCommand() {
        let update = createUpdateWithBotCommand("/otherstart", 0, 11, true)

        let handlerForEdited = CommandHandler(commands: ["/start"], options: [.editedUpdates]) { (_, _) in }
        XCTAssertFalse(handlerForEdited.check(update: update))

        let handler = CommandHandler(commands: ["/otherstart"]) { (_, _) in }
        XCTAssertFalse(handler.check(update: update))

        let handler0ForEdited = CommandHandler(commands: ["/start"]) { (_, _) in }
        XCTAssertFalse(handler0ForEdited.check(update: update))

        let handler0 = CommandHandler(commands: ["/otherstart"], options: [.editedUpdates]) { (_, _) in }
        XCTAssertTrue(handler0.check(update: update))
    }

}
