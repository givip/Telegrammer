//
//  JobQueue.swift
//  Telegrammer
//
//  Created by Givi on 14/03/2019.
//

import Foundation
import HeliumLogger
import LoggerAPI
import HTTP

public class JobQueue {
    private (set) var bot: BotProtocol
    private (set) var worker: Worker

    private (set) var jobs = SynchronizedArray<AnyJob>()

    init(bot: BotProtocol) {
        self.bot = bot
        self.worker = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    }

    func stop() {
        worker.shutdownGracefully { (error) in
            if let error = error {
                Log.error(error.localizedDescription)
            }
        }
    }

    @discardableResult
    func scheduleOnce<J: Job>(_ job: J) throws -> Future<AnyJob> {
        let startTime = job.startTime.timeIntervalSince(Date())

        if startTime < 0 {
            throw CoreError(identifier: "JobQueue", reason: "Job start date is in the past, skipping this job")
        }

        let typeErasedJob = AnyJob(job)

        jobs.append(typeErasedJob)
        
        let scheduledTask = worker.eventLoop.scheduleTask(in: .seconds(Int(round(startTime)))) { () -> AnyJob in
            typeErasedJob.run(bot: self.bot)
            return typeErasedJob
        }

        return scheduledTask.futureResult
    }

    func scheduleRepeated<J: Job>(_ job: J) {
        let startTime = Date().timeIntervalSince(job.startTime)

        let typeErasedJob = AnyJob(job)

        jobs.append(typeErasedJob)

        let initialDelay: TimeAmount = .seconds(Int(startTime))

        worker.eventLoop.scheduleRepeatedTask(initialDelay: initialDelay, delay: typeErasedJob.interval) { (task) in
            Log.info("Job \(job) was successfully executed")
        }
    }
}

public extension JobQueue {
    @discardableResult
    static func runOnce(on bot: BotProtocol, interval: TimeAmount, _ task: @escaping () throws -> ()) throws -> Future<AnyJob> {
        let queue = JobQueue(bot: bot)

        let currentDate = Date()
        let fireDate = Date(timeInterval: TimeInterval(interval.nanoseconds) / 1000000000, since: currentDate)

        let onceJob = AnyJob(OnceJob(when: fireDate, task))

        return try queue.scheduleOnce(onceJob).do { _ in
            queue.stop()
        }
    }
}
