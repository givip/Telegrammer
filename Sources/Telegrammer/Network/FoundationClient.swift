//
//  FoundationClient.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 30.05.2018.
//

import Foundation
import NIO
import HTTP

/// `Client` wrapper around `Foundation.URLSession`.
public final class FoundationClient {
    /// See `Client`.
    public var worker: Worker
    
    /// The `URLSession` powering this client.
    private let urlSession: URLSession
    
    /// Creates a new `FoundationClient`.
    public init(_ urlSession: URLSession, on worker: Worker) {
        self.urlSession = urlSession
        self.worker = worker
    }
    
    /// Creates a `FoundationClient` with default settings.
    public static func `default`(on worker: Worker) -> FoundationClient {
        return .init(.init(configuration: .default), on: worker)
    }
    
    /// See `Client`.
    public func send(_ req: HTTPRequest) -> Future<HTTPResponse> {
        let urlReq = req.convertToFoundationRequest()
        let promise = worker.eventLoop.newPromise(HTTPResponse.self)
        self.urlSession.dataTask(with: urlReq) { data, urlResponse, error in
            if let error = error {
                promise.fail(error: error)
                return
            }
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                let error = CoreError(identifier: "httpURLResponse", reason: "URLResponse was not a HTTPURLResponse.")
                promise.fail(error: error)
                return
            }
            
            let response = HTTPResponse.convertFromFoundationResponse(httpResponse, data: data, on: self.worker)
            promise.succeed(result: HTTPResponse(status: response.status, version: response.version, headers: response.headers, body: response.body))
            }.resume()
        return promise.futureResult
    }
}

// MARK: Private

private extension HTTPRequest {
    /// Converts an `HTTP.HTTPRequest` to `Foundation.URLRequest`
    func convertToFoundationRequest() -> URLRequest {
        let http = self
        let body = http.body.data ?? Data()
        var request = URLRequest(url: http.url)
        request.httpMethod = "\(http.method)"
        request.httpBody = body
        http.headers.forEach { key, val in
            request.addValue(val, forHTTPHeaderField: key.description)
        }
        return request
    }
}

private extension HTTPResponse {
    /// Creates an `HTTP.HTTPResponse` to `Foundation.URLResponse`
    static func convertFromFoundationResponse(_ httpResponse: HTTPURLResponse, data: Data?, on worker: Worker) -> HTTPResponse {
        var res = HTTPResponse(status: .init(statusCode: httpResponse.statusCode))
        if let data = data {
            res.body = HTTPBody(data: data)
        }
        for (key, value) in httpResponse.allHeaderFields {
            res.headers.replaceOrAdd(name: "\(key)", value: "\(value)")
        }
        return res
    }
}
