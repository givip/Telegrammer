//
//  HTTPRequest.swift
//  Telegrammer
//
//  Created by Givi on 06/03/2019.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import HTTP

extension HTTPRequest {
    var urlRequest: URLRequest {
        var request = URLRequest(url: self.url)
        request.httpMethod = "POST"
        request.httpBody = self.body.data
        self.headers.forEach { header in
            request.addValue(header.value, forHTTPHeaderField: header.name)
        }
        return request
    }
}
