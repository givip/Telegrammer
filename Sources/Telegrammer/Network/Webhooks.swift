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
            if !Const.WebhooksSupportedPorts.contains(port) {
                log.warning("Choosed port \(port) isn't supported by Telegram servers.")
            }
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

    private var server: UpdatesServer?

    public init(bot: Bot, dispatcher: Dispatcher, worker: Worker = MultiThreadedEventLoopGroup(numberOfThreads: 1)) {
        self.bot = bot
        self.dispatcher = dispatcher
        self.worker = worker
        self.running = false
    }

    public func start() throws -> Future<Void> {
        guard let config = bot.settings.webhooksConfig else {
            throw CoreError(
                type: .internal,
                reason: "Initialization parameters wasn't found in enviroment variables"
            )
        }

        var cert: InputFile?

        if let publicCert = config.publicCert {
            switch publicCert {
            case .file(url: let url):
                guard let fileHandle = FileHandle(forReadingAtPath: url) else {
                    let errorDescription = "Public key '\(publicCert)' was specified for HTTPS server, but wasn't found"
                    log.error(errorDescription.logMessage)
                    throw CoreError(
                        type: .internal,
                        reason: errorDescription
                    )
                }
                cert = InputFile(data: fileHandle.readDataToEndOfFile(), filename: url)
            case .text(content: let textCert):
                guard let strData = textCert.data(using: .utf8) else {
                    let errorDescription = "Public key body '\(textCert)' was specified for HTTPS server, but it cannot be converted into Data type"
                    log.error(errorDescription.logMessage)
                    throw CoreError(
                        type: .internal,
                        reason: errorDescription
                    )
                }
                cert = InputFile(data: strData, filename: "public.pem")
            }
        }

        let params = Bot.SetWebhookParams(url: config.url, certificate: cert, maxConnections: maxConnections, allowedUpdates: nil)

        return try listenWebhooks(on: config.ip, port: config.port)
            .flatMapThrowing { _  -> Void in
                return try self.bot.setWebhook(params: params)
                    .whenComplete { (result) -> Void in
                        switch result {
                            case .success(let res):
                                log.info("setWebhook request result: \(res)")
                                log.info("Started UpdatesServer, listening for incoming messages...")
                            case .failure(let error):
                                log.error(error.logMessage)
                        }
                    }
        }
    }

    private func listenWebhooks(on host: String, port: Int) throws -> Future<Void> {
        let promise = worker.next().makePromise(of: Void.self)
        let server = UpdatesServer(host: host, port: port, handler: dispatcher)
        try server.start()
            .whenComplete { (result) in
                switch result {
                    case .success:
                        self.server = server
                        self.running = true
                        log.info("HTTP server started on: \(host):\(port)")
                        promise.succeed(())
                    case .failure(let error):
                        log.info("HTTP server failed on: \(host):\(port)")
                        log.error(error.logMessage)
                        promise.fail(error)
                }
        }
        return promise.futureResult
    }

    public func stop() throws -> Future<Void> {
        let promise = worker.next().makePromise(of: Void.self)
        try self.server?.stop()
            .whenSuccess {
                self.running = false
                promise.succeed(())
        }
        return promise.futureResult
    }
}
