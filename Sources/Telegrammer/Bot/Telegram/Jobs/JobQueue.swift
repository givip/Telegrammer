//
//  JobQueue.swift
//  Telegrammer
//
//  Created by Givi on 18/03/2019.
//

import Foundation
import NIO

public protocol JobQueue {
    associatedtype Context

    var jobs: SynchronizedArray<AnyJob<Context>> { get }

    func shutdownQueue()
    func scheduleOnce<J: Job>(_ job: J) throws -> Scheduled<J> where J.Context == Context
    func scheduleRepeated<J: Job>(_ job: J) -> RepeatedTask where J.Context == Context
}
