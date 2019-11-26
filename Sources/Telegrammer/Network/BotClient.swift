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
//            let promise = worker.next().makePromise(of: TelegramContainer<T>.self)

//            URLSession.shared.dataTask(with: request.urlRequest) { (data, response, error) in
//                if let error = error {
//                    promise.fail(error: error)
//                    return
//                }
//                if let data = data {
//                    do {
//                        let response = try JSONDecoder().decode(TelegramContainer<T>.self, from: data)
//                        promise.succeed(result: response)
//                    } catch {
//                        promise.fail(error: error)
//                    }
//                }
//            }.resume()
//
//            return promise.futureResult

        //Due to memory leak in HTTPClient, temporarely switching on URLSession

        return client
            .execute(request: request)
            .flatMapThrowing({ (response) -> TelegramContainer<T> in
                log.info("Decoding response from HTTPClient")
                return try self.decode(response: response)
            })


//        var futureClient: Future<HTTPClient>
//        if let existingClient = client {
//            log.info("Using existing HTTP client")
//            futureClient = Future<HTTPClient>.map(on: worker, { existingClient })
//        } else {
//            futureClient = HTTPClient
//                .connect(scheme: .https, hostname: host, port: port, on: worker, onError: { (error) in
//                    log.info("HTTP Client was down with error: \n\(error.logMessage)")
//                    log.error(error.logMessage)
//                    self.client = nil
//                })
//                .do({ (freshClient) in
//                    log.info("Creating new HTTP Client")
//                    self.client = freshClient
//                })
//        }
//        return futureClient
//            .catch { (error) in
//                log.info("HTTP Client was down with error: \n\(error.logMessage)")
//                log.error(error.logMessage)
//            }
//            .then { (client) -> Future<HTTPResponse> in
//                log.info("Sending request to vapor HTTPClient")
//                return client.send(request)
//            }
//            .map(to: TelegramContainer<T>.self) { (response) -> TelegramContainer<T> in
//                log.info("Decoding response from HTTPClient")
//                return try self.decode(response: response)
//        }
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

