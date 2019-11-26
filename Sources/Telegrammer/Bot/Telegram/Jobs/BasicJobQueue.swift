//
//  BasicJobQueue.swift
//  Telegrammer
//
//  Created by Givi on 14/03/2019.
//

import Foundation
import NIO
import AsyncHTTPClient

public class BasicJobQueue<C>: JobQueue {

    private (set) var bot: BotProtocol
    private (set) var worker: Worker

    public var jobs = SynchronizedArray<AnyJob<C>>()

    public init(bot: BotProtocol) {
        self.bot = bot
        self.worker = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    }

    public func shutdownQueue() {
        worker.shutdownGracefully { (error) in
            if let error = error {
                log.error(error.logMessage)
            }
        }
    }

    @discardableResult
    public func scheduleOnce<J: Job>(_ job: J) throws -> Scheduled<J> where J.Context == C {
        let startTime = job.startTime.timeIntervalSince(Date())

        if startTime < 0 {
            throw CoreError(identifier: "JobQueue", reason: "Job start date is in the past, skipping this job")
        }

        let typeErasedJob = AnyJob(job)

        jobs.append(typeErasedJob)
        
        return worker.eventLoop.scheduleTask(in: .seconds(Int(round(startTime)))) { () -> J in
            try typeErasedJob.run(self.bot)
            return job
        }
    }

    public func scheduleRepeated<J: Job>(_ job: J) -> RepeatedTask where J.Context == C {
        var startTime = job.startTime.timeIntervalSince(Date())

        if startTime < 0 {
            startTime = 0
        }

        let typeErasedJob = AnyJob(job)

        jobs.append(typeErasedJob)

        let initialDelay: TimeAmount = .seconds(Int(round(startTime)))

        return worker.eventLoop.scheduleRepeatedTask(initialDelay: initialDelay, delay: typeErasedJob.interval) { _ in
            try typeErasedJob.run(self.bot)
        }
    }
}

public extension BasicJobQueue {
    @discardableResult
    static func runOnce(on bot: BotProtocol, interval: TimeAmount, _ task: @escaping () throws -> ()) throws -> Future<Void> {
        let queue = BasicJobQueue<Void>(bot: bot)

        let currentDate = Date()
        let fireDate = Date(timeInterval: TimeInterval(interval.nanoseconds) / 1000000000, since: currentDate)

        let onceJob = OnceJob<Void>(when: fireDate) { _ in
            try task()
        }

        return try queue
            .scheduleOnce(onceJob)
            .futureResult
            .map { (job) -> Void in
                queue.shutdownQueue()
            }
    }
}
