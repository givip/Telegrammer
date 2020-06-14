//
//  DailyJob.swift
//  Telegrammer
//
//  Created by Givi on 18/03/2019.
//

import Foundation
import AsyncHTTPClient
import NIO

public class DailyJob<C>: Job {
    public typealias Context = C

    public var id: String

    public var callback: (_ context: C?) throws -> Void

    public var name: String?

    public var enabled: Bool = false

    public var scheduledRemoval: Bool = false

    public var startTime: Date

    public var days: Set<Day>

    public var interval: TimeAmount = .hours(24)

    public var context: C?

    public var scheduler: RepeatedTask?

    public init(
        name: String? = nil,
        days: Set<Day>,
        fireDayTime: TimeAmount,
        context: C? = nil,
        _ callback: @escaping (_ context: C?) throws -> Void
    ) throws {
        let id = UUID().uuidString
        self.id = id
        self.name = name ?? "DailyJob_\(id)"
        self.callback = callback
        self.context = context
        self.days = days

        if days.isEmpty {
            throw CoreError(
                type: .internal,
                reason: "DailyJob cannot be initialized with empty `days` param"
            )
        }

        let currentDate = Date()
        let todayBegin = currentDate.stripTime()

        let plannedTickTime = todayBegin.timeIntervalSince1970 + TimeInterval(fireDayTime.seconds)
        let remainedUntilFirstTick = plannedTickTime - currentDate.timeIntervalSince1970

        if remainedUntilFirstTick > 0 {
            self.startTime = Date(timeIntervalSince1970: plannedTickTime)
        } else {
            self.startTime = todayBegin
                .addingTimeInterval(TimeInterval(TimeAmount.hours(24).seconds + fireDayTime.seconds))
        }
    }

    public func run(_ bot: BotProtocol) throws {
        guard let today = Day.todayWeekDay, days.contains(today) else { return }

        if scheduledRemoval {
            scheduler?.cancel()
        } else {
            try callback(context)
        }
    }

    public func scheduleRemoval() {
        scheduledRemoval = true
    }
}
