//
//  JobQueueTests.swift
//  TelegrammerTests
//
//  Created by Givi on 14/03/2019.
//

import XCTest

@testable import Telegrammer

class MockBot: BotProtocol {}

class JobQueueTests: XCTestCase {

    func testJobQueue_runOnce_correctDelayValue() {

        let bot = MockBot()

        let startDate: TimeInterval = Date().timeIntervalSince1970
        let delay: TimeInterval = 1
        let desiredFinishDate: TimeInterval = startDate + delay

        var finishDate: Date? = nil
        var count = 0

        let expectation = XCTestExpectation(description: "JobQueue.runOnce has finished")

        try! JobQueue.runOnce(on: bot, interval: .seconds(Int(delay))) {
            finishDate = Date()
            count += 1
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: delay + 0.5)

        XCTAssertNotNil(finishDate, "FinishDate must be fulfilled")

        let difference = abs(finishDate!.timeIntervalSince1970 - desiredFinishDate)

        XCTAssert(difference < 0.01, "runOnce fired too early/lately")
        XCTAssert(count == 1, "JobQueue has executed Job more then once")
    }

    func testJobQueue_runOnce_incorrectDelayValue() {
        let bot = MockBot()

        let jobBlock = {
            XCTAssert(false, "Job shouldn't be executed")
        }

        XCTAssertThrowsError(try JobQueue.runOnce(on: bot, interval: .seconds(Int(0)), jobBlock), "Exception wasn't received") { error in
            debugPrint("Error \(error.localizedDescription) was successfully thrown")
        }

        XCTAssertThrowsError(try JobQueue.runOnce(on: bot, interval: .seconds(Int(-1)), jobBlock), "Exception wasn't received") { error in
            debugPrint("Error \(error.localizedDescription) was successfully thrown")
        }
    }

    func testJobQueue_scheduleRepeated_correctDelayValue() {
        let bot = MockBot()
        let queue = JobQueue(bot: bot)

        let repeats = 5.0

        let startDate: TimeInterval = Date().timeIntervalSince1970
        let delay: TimeInterval = 1.0
        let desiredFinishDate: TimeInterval = startDate + repeats * delay

        var finishDate: Date? = nil
        var count = 0

        let job = 

        let expectation = XCTestExpectation(description: "JobQueue.scheduleRepeated has finished")
        let expectations = Array(repeating: expectation, count: Int(repeats))

        queue.scheduleRepeated(<#T##job: Job##Job#>)

        try! JobQueue.runOnce(on: bot, interval: .seconds(Int(delay))) {
            finishDate = Date()
            count += 1
            expectation.fulfill()
        }

        wait(for: expectations, timeout: delay + 0.5)

        XCTAssertNotNil(finishDate, "FinishDate must be fulfilled")

        let difference = abs(finishDate!.timeIntervalSince1970 - desiredFinishDate)

        XCTAssert(difference < 0.01, "runOnce fired too early/lately")
        XCTAssert(count == 1, "JobQueue has executed Job more then once")
    }

    func testJobQueue_scheduleRepeated_incorrectDelayValue() {
//        let bot = MockBot()
//
//        let jobBlock = {
//            XCTAssert(false, "Job shouldn't be executed")
//        }
//
//        XCTAssertThrowsError(try JobQueue.runOnce(on: bot, interval: .seconds(Int(0)), jobBlock), "Exception wasn't received") { error in
//            debugPrint("Error \(error.localizedDescription) was successfully thrown")
//        }
//
//        XCTAssertThrowsError(try JobQueue.runOnce(on: bot, interval: .seconds(Int(-1)), jobBlock), "Exception wasn't received") { error in
//            debugPrint("Error \(error.localizedDescription) was successfully thrown")
//        }
    }

    func testJobQueue_queueShutdownsGracefully() {
        let bot = MockBot()
        let queue = JobQueue(bot: bot)

        var performed = false

        _ = queue.worker.eventLoop
            .submit { () -> Void in
                performed = true
            }
            .do { result in
                XCTAssertTrue(performed, "At this point job shouldn't be performed")
        }

        queue.stop()

        wait(for: [], timeout: 0.5)

        let expectation = XCTestExpectation(description: "EventLoop is gracefully shutdowned")

        expectation.isInverted = true

        _ = queue.worker.eventLoop.submit { () -> Void in
            XCTAssert(false, "At this point job should be shutdowned")
        }

        wait(for: [expectation], timeout: 1)
    }
}
