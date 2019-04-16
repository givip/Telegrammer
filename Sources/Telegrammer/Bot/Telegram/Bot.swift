//
//  Bot.swift
//  Telegrammer
//
//  Created by Givi on 15/03/2019.
//

import Foundation
import HTTP
import Logging

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
        self.client = try BotClient(host: settings.serverHost,
                                    port: settings.serverPort,
                                    token: settings.token,
                                    worker: self.requestWorker)
        self.boundary = String.random(ofLength: 20)
    }

    func wrap<T: Codable>(_ container: TelegramContainer<T>) throws -> Future<T> {

        log.info(logMessage(container))

        if let result = container.result {
            return Future.map(on: self.requestWorker, { result })
        } else {
            throw logError(container)
        }
    }

    func httpBody(for object: Encodable?) throws -> HTTPBody {
        guard let object = object else { return HTTPBody() }

        if let object = object as? JSONEncodable {
            return HTTPBody(data: try object.encodeBody())
        }

        if let object = object as? MultipartEncodable {
            let boundaryBytes = boundary.utf8.map { $0 }
            return HTTPBody(data: try object.encodeBody(boundary: boundaryBytes))
        }

        return HTTPBody()
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

    func logMessage<T: Codable>(_ container: TelegramContainer<T>) -> Logger.Message {
        var resultString = "[]"

        if let result = container.result {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            do {
                let data = try encoder.encode(result)
                if let json = String(data: data, encoding: .utf8) {
                    resultString = json
                }
            } catch {
                if let value = container.result as? Bool {
                    resultString = value.description
                } else {
                    log.error(error.logMessage)
                }
            }
        }

        let logString = """

        Received response
        Code: \(container.errorCode ?? 0)
        Status OK: \(container.ok)
        Description: \(container.description ?? "Empty")
        Result: \(resultString)

        """

        return Logger.Message(stringLiteral: logString)
    }

    func logError<T: Codable>(_ container: TelegramContainer<T>) -> Error {
        let error = CoreError(
            identifier: "DecodingErrors",
            reason: container.description ?? "Response error"
        )
        log.error(error.logMessage)
        return error
    }
}
