//
//  RequestManager.swift
//  TelegrammerPackageDescription
//
//  Created by Givi Pataridze on 25.02.2018.
//

import Foundation
import NIO
import NIOHTTP1
import AsyncHTTPClient

public class BotClient {
    
    let host: String
    let port: Int
    
    let token: String

    var client: HTTPClient

    let worker: Worker
    let callbackWorker: Worker
    
    public init(host: String, port: Int, token: String, worker: Worker) throws {
        self.host = host
        self.port = port
        self.token = token
        self.worker = worker
        self.callbackWorker = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        self.client = HTTPClient(eventLoopGroupProvider: .createNew)
    }
    
    /// Sends request to api.telegram.org, and receive TelegramContainer object
    ///
    /// - Parameters:
    ///   - endpoint: Telegram method endpoint
    ///   - body: Body of request (optional)
    ///   - headers: Custom header of request (By default "Content-Type" : "application/json")
    ///   - client: custom client, if not metioned, uses default
    /// - Returns: Container with response
    /// - Throws: Errors
    func respond<T: Codable>(endpoint: String, body: HTTPClient.Body? = nil, headers: HTTPHeaders = .empty) throws -> Future<TelegramContainer<T>> {
        let url = apiUrl(endpoint: endpoint)
        let httpRequest = try HTTPClient.Request(
            url: url,
            method: .POST,
            headers: headers,
            body: body
        )
        
        let promise = worker.next().makePromise(of: TelegramContainer<T>.self)
        
        log.info("Sending request:\n\(httpRequest.description)")
        
        worker.next().execute {
            self.send(request: httpRequest).whenSuccess({ (container) in
                promise.succeed(container)
            })
        }
        return promise.futureResult
    }
    
    private func send<T: Codable>(request: HTTPClient.Request) -> Future<TelegramContainer<T>> {
        return client
            .execute(request: request)
            .flatMapThrowing({ (response) -> TelegramContainer<T> in
                log.info("Decoding response from HTTPClient")
                return try self.decode(response: response)
            })
    }
    
    func decode<T: Encodable>(response: HTTPClient.Response) throws -> TelegramContainer<T> {
        guard let body = response.body else {
            throw BotError()
        }
        guard let bytes = body.getBytes(at: 0, length: body.writerIndex) else {
            throw BotError()
        }
        return try JSONDecoder().decode(TelegramContainer<T>.self, from: Data(bytes))
    }

    
    func apiUrl(endpoint: String) -> String {
        return "https://\(host):\(port)/bot\(token)/\(endpoint)"
    }
}

extension HTTPClient.Body {
    static var empty: HTTPClient.Body {
        return HTTPClient.Body.string("")
    }
}

