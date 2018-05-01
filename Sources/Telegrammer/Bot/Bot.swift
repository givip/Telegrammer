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
    
    public let client: BotClient
    let requestWorker: Worker
    let boundary: String
    
    public init(token: String, host: String, port: Int, numThreads: Int = 4) throws {
        if let mode = Enviroment.get("debug"), mode == "true" {
            Log.logger = HeliumLogger(.verbose)
            Log.info("Application is in debug mode, with verbose logging")
        }
        
        self.requestWorker = MultiThreadedEventLoopGroup(numThreads: numThreads)
        self.client = try BotClient(host: host, port: port, token: token, worker: self.requestWorker)
        self.boundary = String.random(ofLength: 20)
        Log.info("Initialized Bot instance")
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
                print(error.localizedDescription)
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
        return NSError(domain: container.description ?? "Response error",
                       code: container.errorCode ?? -1,
                       userInfo: nil)
    }
    
}

