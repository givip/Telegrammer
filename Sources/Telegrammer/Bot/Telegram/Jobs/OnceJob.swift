//
//  OnceJob.swift
//  Telegrammer
//
//  Created by Givi on 14/03/2019.
//

import Foundation
import NIO

public class OnceJob<C>: Job {
    public typealias Context = C

    public var id: String

    public var callback: (_ context: C?) throws -> ()

    public var name: String?

    public var enabled: Bool = false

    public var scheduledRemoval: Bool = false

    public var startTime: Date

    public var interval: TimeAmount = .seconds(0)

    public var context: C?

    public var scheduler: Scheduled<OnceJob>?

    public init(name: String? = nil, when: Date, context: C? = nil, _ callback: @escaping (_ context: C?) throws -> ()) {
        let id = UUID().uuidString
        self.id = id
        self.name = name ?? "OnceJob_\(id)"
        self.startTime = when
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
