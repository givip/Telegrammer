//
//  Updater.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 09.04.2018.
//

import HTTP
import NIO

public final class Updater {
    
    public enum LongpollingDefaults {
        public static let pollInterval              = TimeAmount.seconds(0)
        public static let timeout                   = 10
        public static let clean                     = false
        public static let bootstrapRetries: Int?    = nil
        public static let readLatency               = TimeAmount.seconds(2)
        public static let allowedUpdates: [String]? = nil
        public static let limit: Int?               = nil
    }
    
    ///Common
    public let bot: Bot
    public let dispatcher: Dispatcher
    public let worker: Worker
    public var running: Bool
    
    ///Longpolling
    private var lastUpdate: Update?
    private var pollingInterval = LongpollingDefaults.pollInterval
    private var pollingPromise: Promise<Void>?
    
    ///Webhooks
    
    
    public init(bot: Bot, dispatcher: Dispatcher, worker: Worker = MultiThreadedEventLoopGroup(numThreads: 1)) {
        self.bot = bot
        self.dispatcher = dispatcher
        self.worker = worker
        self.running = false
    }
    
    public func longpolling(timeout: Int = LongpollingDefaults.timeout,
                            pollInterval: TimeAmount = LongpollingDefaults.pollInterval,
                            clean: Bool = LongpollingDefaults.clean,
                            bootstrapRetries: Int? = LongpollingDefaults.bootstrapRetries,
                            readLatency: TimeAmount = LongpollingDefaults.readLatency,
                            allowedUpdates: [String]? = LongpollingDefaults.allowedUpdates,
                            limit: Int? = LongpollingDefaults.limit) throws -> Future<Void> {
        self.running = true
        self.pollingInterval = pollInterval
        
        let promise = worker.eventLoop.newPromise(Void.self)
        let params = Bot.GetUpdatesParams(offset: nil, limit: limit, timeout: timeout, allowedUpdates: allowedUpdates)
        
        worker.eventLoop.execute {
            self._longpolling(with: params)
        }
        
        pollingPromise = promise
        return promise.futureResult
    }
    
    public func webhooks() {
        
    }
    
    private func _longpolling(with params: Bot.GetUpdatesParams) {

        var requestBody = params
        
        do {
            let updates = try self.bot.getUpdates(params: requestBody).wait()
            if !updates.isEmpty {
                dispatcher.enqueue(updates: updates)
                if let last = updates.last {
                    requestBody.offset = last.updateId + 1
                }
            }
            self.scheduleLongpolling(with: requestBody)
        } catch {
            running = false
            self.pollingPromise?.fail(error: error)
        }
    }
    
    private func scheduleLongpolling(with params: Bot.GetUpdatesParams) {
        _ = worker.eventLoop.scheduleTask(in: pollingInterval) { () -> Void in
            self._longpolling(with: params)
        }
    }
    
    public func stop() {
        running = false
        worker.eventLoop.execute {
            self.pollingPromise?.succeed()
        }
    }
}
