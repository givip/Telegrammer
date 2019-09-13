//
//  RequestManager.swift
//  TelegrammerPackageDescription
//
//  Created by Givi Pataridze on 25.02.2018.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import HTTP

public class BotClient {
    
    let host: String
    let port: Int
    
    let token: String
    //Due to memory leak in HTTPClient, temporarely switching on URLSession
//    var client: HTTPClient?

    let worker: Worker
    let callbackWorker: Worker
    
    public init(host: String, port: Int, token: String, worker: Worker) throws {
        self.host = host
        self.port = port
        self.token = token
        self.worker = worker
        self.callbackWorker = MultiThreadedEventLoopGroup(numberOfThreads: 1)
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
        
        log.info("Sending request:\n\(httpRequest.description)")
        
        worker.eventLoop.execute {
            self.send(request: httpRequest).whenSuccess({ (container) in
                promise.succeed(result: container)
            })
        }
        return promise.futureResult
    }
    
    private func send<T: Codable>(request: HTTPRequest) -> Future<TelegramContainer<T>> {
            let promise = worker.eventLoop.newPromise(of: TelegramContainer<T>.self)

            URLSession.shared.dataTask(with: request.urlRequest) { (data, response, error) in
                if let error = error {
                    promise.fail(error: error)
                    return
                }
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(TelegramContainer<T>.self, from: data)
                        promise.succeed(result: response)
                    } catch {
                        promise.fail(error: error)
                    }
                }
            }.resume()

            return promise.futureResult

        //Due to memory leak in HTTPClient, temporarely switching on URLSession
/*
        var futureClient: Future<HTTPClient>
        if let existingClient = client {
            log.info("Using existing HTTP client")
            futureClient = Future<HTTPClient>.map(on: worker, { existingClient })
        } else {
            futureClient = HTTPClient
                .connect(scheme: .https, hostname: host, port: port, on: worker, onError: { (error) in
                    log.info("HTTP Client was down with error: \n\(error.logMessage)")
                    log.error(error.logMessage)
                    self.client = nil
                })
                .do({ (freshClient) in
                    log.info("Creating new HTTP Client")
                    self.client = freshClient
                })
        }
        return futureClient
            .catch { (error) in
                log.info("HTTP Client was down with error: \n\(error.logMessage)")
                log.error(error.logMessage)
            }
            .then { (client) -> Future<HTTPResponse> in
                log.info("Sending request to vapor HTTPClient")
                return client.send(request)
            }
            .map(to: TelegramContainer<T>.self) { (response) -> TelegramContainer<T> in
                log.info("Decoding response from HTTPClient")
                return try self.decode(response: response)
        }
 */
    }
    
    func decode<T: Encodable>(response: HTTPResponse) throws -> TelegramContainer<T> {
        ///Temporary workaround for drop current HTTPClient state after each request,
        ///waiting for fixes from Vapor team
        //Due to memory leak in HTTPClient, temporarely switching on URLSession
//        self.client = nil
        if let data = response.body.data {
            return try JSONDecoder().decode(TelegramContainer<T>.self, from: data)
        }
        throw BotError()
    }

    
    func apiUrl(endpoint: String) -> URL {
        return URL(string: "https://\(host):\(port)/bot\(token)/\(endpoint)")!
    }
}
