//
//  Longpolling.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 28.04.2018.
//

import Foundation
import HTTP

public class Longpolling: Connection {
    
    public var bot: Bot
    public var dispatcher: Dispatcher
    public var worker: Worker
    public var running: Bool
    
    public var allowedUpdates: [String]? = nil
    public var limit: Int? = nil
    public var bootstrapRetries: Int? = nil
    public var cleanStart: Bool = false
    public var pollingTimeout: Int = 20
    public var pollingInterval: TimeAmount = TimeAmount.seconds(2)
    
    private var lastUpdate: Update?
    private var connectionRetries: Int = 0
    private var isFirstRequest: Bool = true
    
    private var pollingPromise: Promise<Void>?
    
    public init(bot: Bot, dispatcher: Dispatcher, worker: Worker = MultiThreadedEventLoopGroup(numberOfThreads: 1)) {
        self.bot = bot
        self.dispatcher = dispatcher
        self.worker = worker
        self.running = false
    }
    
    public func start() throws -> Future<Void> {
        self.running = true
        
        let promise = worker.eventLoop.newPromise(Void.self)
        
        pollingPromise = promise
        
        let params = Bot.GetUpdatesParams(offset: nil, limit: limit, timeout: pollingTimeout, allowedUpdates: allowedUpdates)
        
        _ = worker.eventLoop.submit {
            try self.bot.deleteWebhook().whenSuccess({ (success) in
                guard success else { return }
                self.longpolling(with: params)
            })
        }
        
        return promise.futureResult
    }
    
    public func stop() {
        running = false
        worker.eventLoop.execute {
            self.pollingPromise?.succeed()
        }
    }
    
    private func longpolling(with params: Bot.GetUpdatesParams) {
        var requestBody = params
        do {
            try self.bot.getUpdates(params: requestBody)
                .catch { error in
                    self.retryRequest(with: params, after: error)
                }
                .whenSuccess({ (updates) in
                    if !updates.isEmpty {
                        if !self.cleanStart || !(self.cleanStart && self.isFirstRequest) {
                            self.dispatcher.enqueue(updates: updates)
                        }
                        if let last = updates.last {
                            requestBody.offset = last.updateId + 1
                        }
                    }
                    self.isFirstRequest = false
                    self.scheduleLongpolling(with: requestBody)
                })
        } catch {
            log.error(error.logMessage)
            retryRequest(with: params, after: error)
        }
    }
    
    private func scheduleLongpolling(with params: Bot.GetUpdatesParams) {
        _ = worker.eventLoop.scheduleTask(in: pollingInterval) { () -> Void in
            self.longpolling(with: params)
        }
    }
    
    private func retryRequest(with params: Bot.GetUpdatesParams, after error: Error) {
        guard let maxRetries = bootstrapRetries, connectionRetries < maxRetries else {
            running = false
            log.error("Failed connection after \(connectionRetries) retries")
            pollingPromise?.fail(error: error)
            return
        }
        
        connectionRetries += 1
        log.warning("Retry \(connectionRetries) after failed request")
        
        _ = worker.eventLoop.scheduleTask(in: pollingInterval, { () -> Void in
            self.longpolling(with: params)
        })
    }
}
