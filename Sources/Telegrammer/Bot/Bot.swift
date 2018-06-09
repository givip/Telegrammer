//
//  Bot.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 25.02.2018.
//

import Foundation
import HTTP
import HeliumLogger
import LoggerAPI

public final class Bot {
    
    public struct Settings {
        public let token: String
        public let debugMode: Bool
        public var serverHost: String = "api.telegram.org"
        public var serverPort: Int = 443
        public var webhooksIp: String? = nil
        public var webhooksUrl: String? = nil
        public var webhooksPort: Int? = nil
        public var webhooksPublicCert: String? = nil
        public var webhooksPrivateKey: String? = nil
        
        public init(token: String, debugMode: Bool = true) {
            self.token = token
            self.debugMode = debugMode
        }
    }
    
    public let client: BotClient
    public let settings: Settings
    let requestWorker: Worker
    let boundary: String
    
    public init(settings: Settings, numThreads: Int = 4) throws {
        Log.logger = settings.debugMode ? HeliumLogger(.verbose) : HeliumLogger(.error)
        
        self.settings = settings
        self.requestWorker = MultiThreadedEventLoopGroup(numberOfThreads: numThreads)
        self.client = try BotClient(host: settings.serverHost,
                                    port: settings.serverPort,
                                    token: settings.token,
                                    worker: self.requestWorker)
        self.boundary = String.random(ofLength: 20)
    }
    
    func wrap<T: Codable>(_ container: TelegramContainer<T>) throws -> Future<T> {
        
        Log.verbose(logMessage(container))
        
        if let result = container.result {
            return Future.map(on: self.requestWorker, { result })
        } else {
            let error = logError(container)
            Log.error(error.localizedDescription)
            throw error
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
    
    func logMessage<T: Codable>(_ container: TelegramContainer<T>) -> String {
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
                    Log.error(error.localizedDescription)
                }
            }
        }
        
        return """
        
        Received response
        Code: \(container.errorCode ?? 0)
        Status OK: \(container.ok)
        Description: \(container.description ?? "Empty")
        Result: \(resultString)
        
        """
    }
    
    func logError<T: Codable>(_ container: TelegramContainer<T>) -> Error {
        return CoreError(identifier: "DecodingErrors",
                         reason: container.description ?? "Response error")
    }
}
