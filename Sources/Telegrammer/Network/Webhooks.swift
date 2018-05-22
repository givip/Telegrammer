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
import NIO

class Webhooks: Connection {

	public var bot: Bot
	public var dispatcher: Dispatcher
	public var worker: Worker
	public var running: Bool
    
    public var readLatency: TimeAmount = .seconds(2)
    public var clean: Bool = false
    public var maxConnections: Int = 40
	
	private var server: HTTPServer?
	
	public init(bot: Bot, dispatcher: Dispatcher, worker: Worker = MultiThreadedEventLoopGroup(numThreads: 4)) {
		self.bot = bot
		self.dispatcher = dispatcher
		self.worker = worker
		self.running = false
	}
	
	public func start(on host: String, url: String, port: Int, publicCert: String, privateKey: String) throws -> Future<Void> {
        let tlsConfig = TLSConfiguration.forServer(certificateChain: [.file(publicCert)], privateKey: .file(privateKey))
        
        guard let fileHandle = FileHandle(forReadingAtPath: publicCert) else {
            let errorDescription = "Public key '\(publicCert)' for HTTPS server wasn't found"
            Log.error(errorDescription)
            throw CoreError(identifier: "FileIO", reason: errorDescription)
        }
        
        let cert = InputFile(data: fileHandle.readDataToEndOfFile(), filename: publicCert)
        let params = Bot.SetWebhookParams(url: url, certificate: cert, maxConnections: maxConnections, allowedUpdates: nil)
        return try bot.setWebhook(params: params).flatMap { (success) -> Future<Void> in
            Log.info("setWebhook request result: \(success)")
            return try self.listenWebhooks(on: host, port: port, tlsConfig: tlsConfig).onClose
        }
    }
	
    private func listenWebhooks(on host: String, port: Int, tlsConfig: TLSConfiguration) throws -> HTTPServer {
        return try HTTPServer.start(hostname: host, port: port, responder: dispatcher, tlsConfig: tlsConfig, on: worker)
            .do { (server) in
                Log.info("HTTPS server started on: \(host):\(port)")
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
