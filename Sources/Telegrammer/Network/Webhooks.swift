//
//  Webhooks.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 28.04.2018.
//

import Foundation
import AsyncHTTPClient
import NIO

/// Will take care of you Telegram webhooks updates
public class Webhooks: Connection {

    public struct Config {
        public enum Certificate {
            case file(url: String)
            case text(content: String)
        }

        public var ip: String
        public var url: String
        public var port: Int
        public var publicCert: Certificate?

        public init(ip: String, url: String, port: Int, publicCert: Certificate? = nil) {
            self.ip = ip
            self.url = url
            self.port = port
            self.publicCert = publicCert
        }
    }

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
        guard let config = bot.settings.webhooksConfig else {
            throw CoreError(identifier: "Webhooks",
                            reason: "Initialization parameters wasn't found in enviroment variables")
        }

        var cert: InputFile? = nil

        if let publicCert = config.publicCert {
            switch publicCert {
            case .file(url: let url):
                guard let fileHandle = FileHandle(forReadingAtPath: url) else {
                    let errorDescription = "Public key '\(publicCert)' was specified for HTTPS server, but wasn't found"
                    log.error(errorDescription.logMessage)
                    throw CoreError(identifier: "FileIO", reason: errorDescription)
                }
                cert = InputFile(data: fileHandle.readDataToEndOfFile(), filename: url)
            case .text(content: let textCert):
                guard let strData = textCert.data(using: .utf8) else {
                    let errorDescription = "Public key body '\(textCert)' was specified for HTTPS server, but it cannot be converted into Data type"
                    log.error(errorDescription.logMessage)
                    throw CoreError(identifier: "DataType", reason: errorDescription)
                }
                cert = InputFile(data: strData, filename: "public.pem")
            }
        }

        let params = Bot.SetWebhookParams(url: config.url, certificate: cert, maxConnections: maxConnections, allowedUpdates: nil)
        return try bot.setWebhook(params: params).flatMap { (success) -> Future<Void> in
            log.info("setWebhook request result: \(success)")
            return try self.listenWebhooks(on: config.ip, port: config.port).then { $0.onClose }
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
