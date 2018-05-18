//
//  Longpolling.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 28.04.2018.
//

import Foundation
import LoggerAPI
import HeliumLogger
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
    
	public init(bot: Bot, dispatcher: Dispatcher, worker: Worker = MultiThreadedEventLoopGroup(numThreads: 1)) {
		self.bot = bot
		self.dispatcher = dispatcher
		self.worker = worker
		self.running = false
	}
	
	public func start() throws -> Future<Void> {
		self.running = true
		
		let promise = worker.eventLoop.newPromise(Void.self)
		let params = Bot.GetUpdatesParams(offset: nil, limit: limit, timeout: pollingTimeout, allowedUpdates: allowedUpdates)
		
		worker.eventLoop.execute {
			self.longpolling(with: params)
		}
		
		pollingPromise = promise
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
			let updates = try self.bot.getUpdates(params: requestBody).wait()
			if !updates.isEmpty {
                if !cleanStart || !(cleanStart && isFirstRequest) {
                    dispatcher.enqueue(updates: updates)
                }
				if let last = updates.last {
					requestBody.offset = last.updateId + 1
				}
			}
            isFirstRequest = false
			self.scheduleLongpolling(with: requestBody)
		} catch {
            Log.error(error.localizedDescription)
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
            Log.debug("Failed connection after \(connectionRetries) retries")
            pollingPromise?.fail(error: error)
            return
        }
        
        connectionRetries += 1
        Log.debug("Retry \(connectionRetries) after failed request")
        
        _ = worker.eventLoop.scheduleTask(in: pollingInterval, { () -> Void in
            self.longpolling(with: params)
        })
    }
}
