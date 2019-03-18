//
//  OnceJob.swift
//  Telegrammer
//
//  Created by Givi on 14/03/2019.
//

import Foundation
import NIO

class OnceJob: Job {
    var id: String

    var callback: () throws -> ()

    var name: String?

    var enabled: Bool = false

    var removed: Bool = false

    let repeateable: Bool = false

    var startTime: Date

    let interval: TimeAmount = .seconds(0)

    let days: [Day] = []

    var context: Any?
    var jobQueue: JobQueue?

    init(name: String? = nil, when: Date, context: Any? = nil, _ callback: @escaping () throws -> ()) {
        let id = UUID().uuidString
        self.id = id
        self.name = name ?? "OnceJob_\(id)"
        self.startTime = when
        self.callback = callback
        self.context = context
    }

    func run(bot: BotProtocol) {
        try! callback()
    }

    func scheduleRemoval() {}
}
