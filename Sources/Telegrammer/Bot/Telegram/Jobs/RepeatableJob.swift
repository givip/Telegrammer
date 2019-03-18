//
//  RepeatableJob.swift
//  Telegrammer
//
//  Created by Givi on 14/03/2019.
//

import Foundation
import NIO

public class RepeatableJob<C>: Job {
    public typealias Context = C

    public var id: String

    public var callback: (_ context: C?) throws -> ()

    public var name: String?

    public var enabled: Bool = false

    public var scheduledRemoval: Bool = false

    public var startTime: Date

    public var interval: TimeAmount

    public var context: C?

    public var scheduler: RepeatedTask?

    public init(name: String? = nil, when: Date, interval: TimeAmount, context: C? = nil, _ callback: @escaping (_ context: C?) throws -> ()) {
        let id = UUID().uuidString
        self.id = id
        self.name = name ?? "RepeatableJob_\(id)"
        self.startTime = when
        self.interval = interval
        self.callback = callback
        self.context = context
    }

    public func run(_ bot: BotProtocol) throws {
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
