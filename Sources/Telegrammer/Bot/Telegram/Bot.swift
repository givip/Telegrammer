//
//  Bot.swift
//  Telegrammer
//
//  Created by Givi on 15/03/2019.
//

import Foundation
import Logging
import NIO
import NIOHTTP1
import AsyncHTTPClient


public typealias Worker = EventLoopGroup

public final class Bot: BotProtocol {

    /// Bot parameters container for initial setup, also contains Webhoos seetings
    public struct Settings {
        public let token: String
        public let debugMode: Bool
        public var serverHost: String = "api.telegram.org"
        public var serverPort: Int = 443
        public var webhooksConfig: Webhooks.Config? = nil

        public init(token: String, debugMode: Bool = true) {
            self.token = token
            self.debugMode = debugMode
        }
    }

    /// HTTP client for bot
    public let client: BotClient

    /// Bot parameters container
    public let settings: Settings

    let requestWorker: Worker
    let boundary: String

    public convenience init(token: String) throws {
        try self.init(settings: Bot.Settings(token: token))
    }

    public init(settings: Settings, numThreads: Int = System.coreCount) throws {
        self.settings = settings
        self.requestWorker = MultiThreadedEventLoopGroup(numberOfThreads: numThreads)
        self.client = try BotClient(
            host: settings.serverHost,
            port: settings.serverPort,
            token: settings.token,
            worker: self.requestWorker
        )
        self.boundary = String.random(ofLength: 20)
    }

    func processContainer<T: Codable>(_ container: TelegramContainer<T>) throws -> T {
        guard container.ok else {
            let desc = """
            Response marked as `not Ok`, it seems something wrong with request
            Code: \(container.errorCode ?? -1)
            \(container.description ?? "Empty")
            """
            let error = CoreError(
                type: .server,
                description: desc
            )
            log.error(error.logMessage)
            throw error
        }

        guard let result = container.result else {
            let error = CoreError(
                type: .server,
                reason: "Response marked as `Ok`, but doesn't contain `result` field."
            )
            log.error(error.logMessage)
            throw error
        }

        let logString = """

        Response:
        Code: \(container.errorCode ?? 0)
        Status OK: \(container.ok)
        Description: \(container.description ?? "Empty")

        """
        log.debug(logString.logMessage)
        return result
    }

    func httpBody(for object: Encodable?) throws -> HTTPClient.Body {
        guard let object = object else { return HTTPClient.Body.empty }

        if let object = object as? JSONEncodable {
            return HTTPClient.Body.data(try object.encodeBody())
        }

        if let object = object as? MultipartEncodable {
            return HTTPClient.Body.string(try object.encodeBody(boundary: boundary))
        }

        return HTTPClient.Body.string("")
    }

    func httpHeaders(for object: Encodable?) -> HTTPHeaders {
        guard let object = object else { return HTTPHeaders() }

        if object is JSONEncodable {
            return HTTPHeaders.contentJson
        }

        if object is MultipartEncodable {
            return HTTPHeaders.typeFormData(boundary: boundary)
        }

        return HTTPHeaders()
    }
}
