//
//  RequestManager.swift
//  TelegrammerPackageDescription
//
//  Created by Givi Pataridze on 25.02.2018.
//

import Foundation
import HTTP
import LoggerAPI

public class BotClient {
    
    let host: String
    let port: Int
    
    let token: String
    var client: HTTPClient?
    let worker: Worker
    let callbackWorker: Worker
    
    public init(host: String, port: Int, token: String, worker: Worker) throws {
        self.host = host
        self.port = port
        self.token = token
        self.worker = worker
        self.callbackWorker = MultiThreadedEventLoopGroup(numThreads: 1)
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
    func respond<T: Codable>(endpoint: String, body: HTTPBody, headers: HTTPHeaders) throws -> Future<TelegramContainer<T>> {
        let url = apiUrl(endpoint: endpoint)
        let httpRequest = HTTPRequest(method: .POST, url: url, headers: headers, body: body)
        
        let promise = worker.eventLoop.newPromise(TelegramContainer<T>.self)
        
        Log.info("Sending request:\n\(httpRequest.description)")
        
        worker.eventLoop.execute {
            self.send(request: httpRequest).whenSuccess({ (container) in
                promise.succeed(result: container)
            })
        }
        return promise.futureResult
    }
    
    private func send<T: Codable>(request: HTTPRequest) -> Future<TelegramContainer<T>> {
        var futureClient: Future<HTTPClient>
        if let existingClient = client {
            Log.info("Using existing HTTP client")
            futureClient = Future<HTTPClient>.map(on: worker, { existingClient })
        } else {
            futureClient = HTTPClient
                .connect(scheme: .https, hostname: host, port: port, on: worker, onError: { (error) in
                    Log.info("HTTP Client was down with error: \n\(error.localizedDescription)")
                    Log.error(error.localizedDescription)
                    self.client = nil
                })
                .do({ (freshClient) in
                    Log.info("Creating new HTTP Client")
                    self.client = freshClient
                })
        }
        return futureClient
            .catch { (error) in
                Log.info("HTTP Client was down with error: \n\(error.localizedDescription)")
                Log.error(error.localizedDescription)
            }
            .then { (client) -> Future<HTTPResponse> in
                Log.info("Sending request to vapor HTTPClient")
                return client.send(request)
            }
            .map(to: TelegramContainer<T>.self) { (response) -> TelegramContainer<T> in
                Log.info("Decoding response from HTTPClient")
                return try self.decode(response: response)
        }
    }
    
    func decode<T: Encodable>(response: HTTPResponse) throws -> TelegramContainer<T> {
        if let data = response.body.data {
            return try JSONDecoder().decode(TelegramContainer<T>.self, from: data)
        }
        return TelegramContainer(ok: false, result: nil, description: nil, errorCode: nil)
    }
    
    func apiUrl(endpoint: String) -> URL {
        return URL(string: "https://\(host):\(port)/bot\(token)/\(endpoint)")!
    }
}
