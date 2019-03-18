//
//  RepeatableJob.swift
//  Telegrammer
//
//  Created by Givi on 14/03/2019.
//

import Foundation
import NIO

class RepeatableJob: Job {
    var id: String

    var callback: () throws -> ()

    var name: String?

    var enabled: Bool = false

    var removed: Bool = false

    let repeateable: Bool = true

    var startTime: Date

    var interval: TimeAmount

    var days: [Day]

    var context: Any?
    var jobQueue: JobQueue?

    init(name: String? = nil, when: Date, interval: TimeAmount, days: [Day], context: Any? = nil, _ callback: @escaping () throws -> ()) {
        let id = UUID().uuidString
        self.id = id
        self.name = name ?? "OnceJob_\(id)"
        self.startTime = when
        self.interval = interval
        self.callback = callback
        self.context = context
        self.days = days
    }

    func run(bot: BotProtocol) {
        if days.contains(.todayWeekDay) {
            try! callback()
        }
    }

    func scheduleRemoval() {
        
    }
}
