//
//  Webhooks.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 28.04.2018.
//

import Foundation
import HeliumLogger
import LoggerAPI
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
                      url: String,
					  port: Int,
                      publicCert: String,
                      privateKey: String,
					  readLatency: TimeAmount = ReadLatency,
					  clean: Bool = Clean,
					  maxConnections: Int = MaxConnections) throws -> Future<Void> {
        let tlsConfig = TLSConfiguration.forServer(certificateChain: [.file(publicCert)], privateKey: .file(privateKey))
        
        guard let fileData = try Bundle.file(with: publicCert) else {
            Log.error("Public key '\(publicCert)' for HTTPS server wasn't found")
            return Future.map(on: worker, { })
        }
        
        let cert = InputFile(data: fileData, filename: publicCert)
        self.running = true
        let params = Bot.SetWebhookParams(url: url, certificate: cert, maxConnections: maxConnections, allowedUpdates: nil)
        return try bot.setWebhook(params: params).flatMap { (success) -> Future<Void> in
            Log.debug("setWebhook request result: \(success)")
            return try self.listenWebhooks(on: host, port: port, tlsConfig: tlsConfig).onClose
        }
    }
	
    private func listenWebhooks(on host: String, port: Int, tlsConfig: TLSConfiguration) throws -> HTTPServer {
        return try HTTPServer.start(hostname: host, port: port, responder: dispatcher, tlsConfig: tlsConfig, on: worker)
            .do { (server) in
                self.server = server
                self.running = true
            }
            .wait()
    }
	
	public func stop() {
		self.running = false
		_ = self.server?.close()
	}
}
