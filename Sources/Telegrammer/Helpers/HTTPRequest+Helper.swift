//
//  HTTPRequest.swift
//  Telegrammer
//
//  Created by Givi on 06/03/2019.
//

import Foundation
import AsyncHTTPClient

extension HTTPClient.Request {
    var description: String {
        """
        \(self.method.rawValue) \(self.url.absoluteString)
        \(self.headers.description)
        \(self.body.debugDescription)
        """
    }
}
