//
//  Bot.Settings+Proxy.swift
//  AsyncHTTPClient
//
//  Created by Ярослав Попов on 07.01.2020.
//

import Foundation
import AsyncHTTPClient

public extension Bot.Settings {
    struct Proxy {
        public var host: String
        public var port: Int
        public var authorization: Authorization?
        
        public static func server(host: String, port: Int, authorization: Authorization? = nil) -> Proxy {
            return .init(host: host, port: port, authorization: authorization)
        }
    }
}

public extension Bot.Settings.Proxy {
    enum Authorization {
        case basic(username: String, password: String)
        case basicWithCredentials(credentials: String)
        case bearer(tokens: String)
    }
}

extension HTTPClient.Configuration.Proxy {
    init(proxy: Bot.Settings.Proxy) {
        self = Self.server(host: proxy.host,
                           port: proxy.port,
                           authorization: proxy.authorization.map(HTTPClient.Authorization.init))
    }
}

extension HTTPClient.Authorization {
    init(authorization: Bot.Settings.Proxy.Authorization) {
        switch authorization {
        case .basic(let username, let password):
            self = .basic(username: username, password: password)
        case .basicWithCredentials(let credentials):
            self = .basic(credentials: credentials)
        case .bearer(let tokens):
            self = .bearer(tokens: tokens)
        }
    }
}
