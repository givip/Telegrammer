//
//  RequestManager.swift
//  TelegrammerPackageDescription
//
//  Created by Givi Pataridze on 25.02.2018.
//

import Foundation
import HTTP

public class BotClient {
    
    let token: String
    let client: HTTPClient
    let worker: Worker
    let callbackWorker: Worker
    
    public init(host: String, port: Int, token: String, worker: Worker) throws {
        self.token = token
        self.worker = worker
        self.callbackWorker = MultiThreadedEventLoopGroup(numThreads: 1)
        self.client = try HTTPClient.connect(scheme: .https, hostname: host, on: self.worker).wait()
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
    func respond<T: Decodable>(endpoint: String, body: HTTPBody, headers: HTTPHeaders) throws -> Future<TelegramContainer<T>> {
        let url = apiUrl(endpoint: endpoint)
        let httpRequest = HTTPRequest(method: .POST, url: url, headers: headers, body: body)
        let promise = worker.eventLoop.newPromise(HTTPResponse.self)
        worker.eventLoop.execute {
            let result = self.client.send(httpRequest)
            result.whenSuccess({ (response) in
                promise.succeed(result: response)
            })
        }
        return promise.futureResult.map(to: TelegramContainer<T>.self, { (response) -> TelegramContainer<T> in
            return try self.decode(response: response)
        })
    }
    
    func decode<T: Encodable>(response: HTTPResponse) throws -> TelegramContainer<T> {
        if let data = response.body.data {
            return try JSONDecoder().decode(TelegramContainer<T>.self, from: data)
        }
        return TelegramContainer(ok: false, result: nil, description: nil, errorCode: nil)
    }
    
    func apiUrl(endpoint: String) -> URL {
        return URL(string: "https://api.telegram.org/bot\(token)/\(endpoint)")!
    }
}
