//
//  DailyJobTests.swift
//  TelegrammerTests
//
//  Created by Givi on 18/03/2019.
//

import XCTest

@testable import Telegrammer

class DailyJobTests: XCTestCase {
    func testDailyJob_initWithEmptyDays() {
        XCTAssertThrowsError(try DailyJob<Any>(days: [], fireDayTime: .seconds(0), { _ in }), "Exception wasn't received") { error in
            debugPrint("Error \(error.localizedDescription) was successfully thrown")
        }
    }

    func testDailyJob_initWithOneDay() {
        let bot = MockBot()

        let timeout = 3.0
        let currentDate = Date()
        let currentBeginDate = currentDate.stripTime()
        let plannedTickTime = currentDate.addingTimeInterval(timeout)
        let inCoupleSeconds = plannedTickTime - currentBeginDate.timeIntervalSince1970

        let expectation = XCTestExpectation(description: "DailyJob expectation")

        let job = try! DailyJob<Any>(
            days: [Day.todayWeekDay!],
            fireDayTime: .seconds(Int64(round(inCoupleSeconds.timeIntervalSince1970)))
        ) { _ in 
            let fireDate = Date()
            let result = fireDate.isCloseTo(plannedTickTime, accuracy: 0.1)
            XCTAssert(result, "Should be fireded within couple seconds")
            expectation.fulfill()
        }

        _ = BasicJobQueue(bot: bot).scheduleRepeated(job)

        wait(for: [expectation], timeout: timeout + 0.5)
    }
}
