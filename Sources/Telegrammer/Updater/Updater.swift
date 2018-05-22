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
	
	private var longpollingConnection: Longpolling!
    private var webhooksListener: Webhooks!
	
	@discardableResult
    public init(bot: Bot, dispatcher: Dispatcher, worker: Worker = MultiThreadedEventLoopGroup(numThreads: 1)) {
        self.bot = bot
        self.dispatcher = dispatcher
        self.worker = worker
    }
    
    public func startWebhooks() throws -> Future<Void> {
        guard let ip = Enviroment.get("TELEGRAMMER_IP"),
            let url = Enviroment.get("TELEGRAMMER_WEBHOOK_URL"),
            let portString = Enviroment.get("TELEGRAMMER_PORT"),
            let port = Int(portString),
            let publicCert = Enviroment.get("TELEGRAMMER_PUBLIC_KEY"),
            let privateKey = Enviroment.get("TELEGRAMMER_PRIVATE_KEY") else {
                throw CoreError(identifier: "Webhooks",
                                reason: "Initialization parameters wasn't found in enviroment variables")
        }
        
        webhooksListener = Webhooks(bot: bot, dispatcher: dispatcher, worker: worker)
        return try webhooksListener.start(on: ip, url: url, port: port, publicCert: publicCert, privateKey: privateKey)
    }
	
	public func startLongpolling() throws {
		longpollingConnection = Longpolling(bot: bot, dispatcher: dispatcher, worker: worker)
		try longpollingConnection.start().wait()
	}
	
    public func stop() {
        if let longpollingConnection = longpollingConnection {
            longpollingConnection.stop()
        }
        if let webhooksListener = webhooksListener {
            webhooksListener.stop()
        }
    }
}
