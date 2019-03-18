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

        try! BasicJobQueue.runOnce(on: bot, interval: .seconds(Int(delay))) {
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

        XCTAssertThrowsError(try BasicJobQueue.runOnce(on: bot, interval: .seconds(Int(0)), jobBlock), "Exception wasn't received") { error in
            debugPrint("Error \(error.localizedDescription) was successfully thrown")
        }

        XCTAssertThrowsError(try BasicJobQueue.runOnce(on: bot, interval: .seconds(Int(-1)), jobBlock), "Exception wasn't received") { error in
            debugPrint("Error \(error.localizedDescription) was successfully thrown")
        }
    }

    func testJobQueue_scheduleRepeated_correctDelayValue() {
        let bot = MockBot()
        let queue = BasicJobQueue(bot: bot)

        let repeats: Int = 5

        let startDate: TimeInterval = Date().timeIntervalSince1970
        let delay: TimeInterval = 0.1
        let desiredFinishDate: TimeInterval = startDate + Double(repeats) * delay

        var finishDate: Date? = nil
        var count = 0

        var expectations: [XCTestExpectation] = []

        for i in 0..<repeats {
            expectations.append(XCTestExpectation(description: "Job run #\(i)"))
        }

        let job = RepeatableJob(when: Date(), interval: .milliseconds(Int(delay * 1000))) {
            let currentDate = Date()
            finishDate = currentDate

            let isValid = currentDate.isCloseTo(Date(timeIntervalSince1970: startDate + Double(count) * delay), accuracy: 0.01)
            XCTAssert(isValid, "Timer was fired in incorrect time")

            expectations[count].fulfill()
            count += 1
        }

        _ = queue.scheduleRepeated(job)

        wait(for: expectations, timeout: desiredFinishDate + 0.5)

        XCTAssert(count == 5, "Timer wasn't fired desired amount of times")
        XCTAssertNotNil(finishDate, "finishDate must be fulfilled")
    }

    func testJobQueue_queueShutdownsGracefully() {
        let bot = MockBot()
        let queue = BasicJobQueue(bot: bot)

        var performed = false

        _ = queue.worker.eventLoop
            .submit { () -> Void in
                performed = true
            }
            .do { result in
                XCTAssertTrue(performed, "At this point job shouldn't be performed")
        }

        queue.shutdownQueue()

        wait(for: [], timeout: 1)

        let expectation = XCTestExpectation(description: "EventLoop is gracefully shutdowned")

        expectation.isInverted = true

        _ = queue.worker.eventLoop.submit { () -> Void in
            XCTAssert(false, "At this point job should be shutdowned")
        }

        wait(for: [expectation], timeout: 1)
    }
}
