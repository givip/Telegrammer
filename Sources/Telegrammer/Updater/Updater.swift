//
//  Updater.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 09.04.2018.
//

import HTTP
import NIO

/**
 This class purpose is to receive the updates from Telegram and to deliver them to said dispatcher.
 It also runs in a separate thread, so the user can interact with the bot.
 The updater can be started as a polling service or, for production, use a webhook to receive updates.
 This is achieved using the Webhooks and Longpolling classes.
 */
public final class Updater {
	
    /// Bot instance which perform requests and establish http server
    public let bot: Bot
    
    /// Dispatcher instance, which handle all updates from Telegram
    public let dispatcher: Dispatcher
    
    /// EventLoopGroup for networking stuff
    public let worker: Worker

	private var longpollingConnection: Longpolling!
    private var webhooksListener: Webhooks!
	
	@discardableResult
    public init(bot: Bot, dispatcher: Dispatcher, worker: Worker = MultiThreadedEventLoopGroup(numberOfThreads: 1)) {
        self.bot = bot
        self.dispatcher = dispatcher
        self.worker = worker
    }
    
    /**
     Call this method to start receiving Webhooks from Telegram servers.
     
     Note: Bot instance must being set up to receive Webhooks updates
     
     - Throws: Throws on errors
     - Returns: Future of `Void` type
     */
    public func startWebhooks() throws -> Future<Void> {
        webhooksListener = Webhooks(bot: bot, dispatcher: dispatcher, worker: worker)
        return try webhooksListener.start()
    }
	
    /**
     Call this method to start receiving updates from Telegram by longpolling.
     
     Note: Bot instance must being set up to receive Longpolling updates
     
     - Throws: Throws on errors
     - Returns: Future of `Void` type
     */
	public func startLongpolling() throws -> Future<Void> {
		longpollingConnection = Longpolling(bot: bot, dispatcher: dispatcher, worker: worker)
		return try longpollingConnection.start()
	}
	
    /**
     Call this method to stop receiving updates from Telegram.
     */
    public func stop() {
        if let longpollingConnection = longpollingConnection {
            longpollingConnection.stop()
        }
        if let webhooksListener = webhooksListener {
            webhooksListener.stop()
        }
    }
}
