//
//  Webhooks.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 28.04.2018.
//

import Foundation
import HTTP

class Webhooks: Connection {
	
	public static let ReadLatency     = TimeAmount.seconds(2)
	public static let Clean: Bool     = false
	public static let MaxConnections  = 40
	
	
	public var bot: Bot
	public var dispatcher: Dispatcher
	public var worker: Worker
	public var running: Bool
	
	private var server: HTTPServer?
	
	public init(bot: Bot, dispatcher: Dispatcher, worker: Worker = MultiThreadedEventLoopGroup(numThreads: 4)) {
		self.bot = bot
		self.dispatcher = dispatcher
		self.worker = worker
		self.running = false
	}
	
	public func start(on host: String,
					  port: Int,
					  urlPath: String,
					  cert: InputFile,
					  secret: InputFile,
					  readLatency: TimeAmount = ReadLatency,
					  clean: Bool = Clean,
					  maxConnections: Int = MaxConnections) throws {
		self.running = true

		let params = Bot.SetWebhookParams(url: urlPath, certificate: cert, maxConnections: maxConnections, allowedUpdates: nil)
		
		_ = try bot.setWebhook(params: params).whenSuccess( { (result) in
			self.listenWebhooks(on: host, port: port)
		})
	}
	
	private func listenWebhooks(on host: String, port: Int) {
		let server = HTTPServer.start(hostname: host,
									  port: port,
									  responder: dispatcher,
									  maxBodySize: 1_000_000,
									  backlog: 256,
									  reuseAddress: true,
									  tcpNoDelay: true,
									  upgraders: [],
									  on: worker,
									  onError: { _ in })
		server.whenSuccess { (server) in
			self.server = server
			self.running = true
		}
	}
	
	public func stop() {
		self.running = false
		_ = self.server?.close()
	}
}
