//
//  Webhooks.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 28.04.2018.
//

import Foundation
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
    
    public init(bot: Bot, dispatcher: Dispatcher, worker: Worker = MultiThreadedEventLoopGroup(numberOfThreads: 4)) {
        self.bot = bot
        self.dispatcher = dispatcher
        self.worker = worker
        self.running = false
    }
    
    public func start() throws -> Future<Void> {
        guard let ip = bot.settings.webhooksIp,
            let url = bot.settings.webhooksUrl,
            let port = bot.settings.webhooksPort else {
                throw CoreError(identifier: "Webhooks",
                                reason: "Initialization parameters wasn't found in enviroment variables")
        }
        
        var cert: InputFile? = nil
        
        if let publicCert = bot.settings.webhooksPublicCert {
            guard let fileHandle = FileHandle(forReadingAtPath: publicCert) else {
                let errorDescription = "Public key '\(publicCert)' was specified for HTTPS server, but wasn't found"
                log.error(errorDescription.logMessage)
                throw CoreError(identifier: "FileIO", reason: errorDescription)
            }
            cert = InputFile(data: fileHandle.readDataToEndOfFile(), filename: publicCert)
        }
        
        let params = Bot.SetWebhookParams(url: url, certificate: cert, maxConnections: maxConnections, allowedUpdates: nil)
        return try bot.setWebhook(params: params).flatMap { (success) -> Future<Void> in
            log.info("setWebhook request result: \(success)")
            return try self.listenWebhooks(on: ip, port: port).then { $0.onClose }
        }
    }
    
    private func listenWebhooks(on host: String, port: Int) throws -> Future<HTTPServer> {
        return HTTPServer.start(hostname: host, port: port, responder: dispatcher, on: worker)
            .do { (server) in
                log.info("HTTP server started on: \(host):\(port)")
                self.server = server
                self.running = true
        }
    }
    
    public func stop() {
        self.running = false
        _ = self.server?.close()
    }
}
