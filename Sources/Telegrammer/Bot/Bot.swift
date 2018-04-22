//
//  Bot.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 25.02.2018.
//

import NIO
import HTTP
import Foundation

public final class Bot {
    
    public let client: BotClient
    let requestWorker: Worker
    let boundary: String
    
    public init(token: String, host: String, port: Int) throws {
        self.requestWorker = MultiThreadedEventLoopGroup(numThreads: 1)
        self.client = try BotClient(host: host, port: port, token: token, worker: self.requestWorker)
        self.boundary = String.random(ofLength: 20)
    }
    
    func wrap<T: Codable>(_ container: TelegramContainer<T>) throws -> Future<T> {
        if let result = container.result {
            return Future.map(on: self.requestWorker, { result })
        } else {
            let error = logError(container)
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
    
    func httpHeaders(for object: Encodable?) throws -> HTTPHeaders {
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
        return """
        Received response \(Date())
        Status OK: \(container.ok)
        Description: \(container.description ?? "Empty")
        Result: \(String(describing: container.result))
        Code: \(container.errorCode ?? 0)
        
        """
    }
    
    func logError<T: Codable>(_ container: TelegramContainer<T>) -> Error {
        return NSError(domain: container.description ?? "Response error",
                       code: container.errorCode ?? -1,
                       userInfo: nil)
    }
    
}

