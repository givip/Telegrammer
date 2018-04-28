//
//  Updater.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 09.04.2018.
//

import HTTP
import NIO

public final class Updater {
	
    public let bot: Bot
    public let dispatcher: Dispatcher
    public let worker: Worker
    public var running: Bool
	
	private var longpollingConnection: Longpolling?
//	private var webhooksListener: Webhooks?
	
	@discardableResult
    public init(bot: Bot, dispatcher: Dispatcher, worker: Worker = MultiThreadedEventLoopGroup(numThreads: 1)) {
        self.bot = bot
        self.dispatcher = dispatcher
        self.worker = worker
        self.running = false
    }
    
    public func startWebhooks() {
        
    }
	
	public func startLongpolling() throws {
		longpollingConnection = Longpolling(bot: bot, dispatcher: dispatcher, worker: worker)
		try longpollingConnection?.start().wait()
	}
	
    public func stop() {
        longpollingConnection?.stop()
    }
}
