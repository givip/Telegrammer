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

    /// Default init for BotClient (HTTP client), all parameters except `proxy` are oblibatory
    /// - Parameters:
    ///   - host: Host for requests (without scheme)
    ///   - port: Port for requests
    ///   - token: Bot auth token
    ///   - worker: Worker on which will be performed request
    ///   - proxy: Proxy parameters
    public init(
        host: String,
        port: Int,
        token: String,
        worker: HTTPClient.EventLoopGroupProvider,
        proxy: HTTPClient.Configuration.Proxy? = nil
    ) throws {
        self.host = host
        self.port = port
        self.token = token
        let config = HTTPClient.Configuration(
            certificateVerification: .fullVerification,
            proxy: proxy
        )
        self.client = HTTPClient(eventLoopGroupProvider: worker, configuration: config)
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
    func request<T: Codable>(
        endpoint: String,
        body: HTTPClient.Body? = nil,
        headers: HTTPHeaders = .empty
    ) throws -> Future<TelegramContainer<T>> {
        let url = apiUrl(endpoint: endpoint)
        let request = try HTTPClient.Request(
            url: url,
            method: .POST,
            headers: headers,
            body: body
        )

        log.info("Sending request:\n\(request.description)")

        return client
            .execute(request: request)
            .flatMapThrowing({ (response) -> TelegramContainer<T> in
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
        return .string("")
    }
}

#if compiler(>=5.5)
// MARK: Concurrency Support
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension BotClient {

    /// Sends request to api.telegram.org, and receive TelegramContainer object
    ///
    /// - Parameters:
    ///   - endpoint: Telegram method endpoint
    ///   - body: Body of request (optional)
    ///   - headers: Custom header of request (By default "Content-Type" : "application/json")
    ///   - client: custom client, if not metioned, uses default
    /// - Returns: Container with response
    /// - Throws: Errors
    func request<T: Codable>(
        endpoint: String,
        body: HTTPClient.Body? = nil,
        headers: HTTPHeaders = .empty
    ) async throws -> TelegramContainer<T> {
        let url = apiUrl(endpoint: endpoint)
        let request = try HTTPClient.Request(
            url: url,
            method: .POST,
            headers: headers,
            body: body
        )

        log.info("Sending request:\n\(request.description)")
        
        return try await withCheckedThrowingContinuation {
            client
                .execute(request: request)
                .flatMapThrowing({ (response) -> TelegramContainer<T> in
                    return try self.decode(response: response)
                })
                .whenComplete($0.resume(with: ))
        }
    }
}
#endif
