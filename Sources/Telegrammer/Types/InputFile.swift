//
//  InputFile.swift
//  App
//
//  Created by Givi Pataridze on 28.02.2018.
//

import Foundation
import MultipartKit
import NIO

/**
 This object represents the contents of a file to be uploaded. Must be posted using multipart/form-data in the usual way that files are uploaded via the browser.
 
 SeeAlso Telegram Bot API Reference:
 [Input Files](https://core.telegram.org/bots/api#inputfile)
 */
public struct InputFile: Encodable, MultipartPartConvertible {

    public var multipart: MultipartPart? {
        //Will be good to use something like CaseInsensitiveString as key
        var headers: [(String, String)] = []

        var nameStr = ""
        if let name = name {
            nameStr = "; name=\"\(name)\""
        }

        headers.append(("Content-Disposition", "form-data\(nameStr); filename=\"\(filename)\""))

        if let mime = mimeType {
            headers.append(("Content-Type", "\(mime)"))
        }

        guard let multipart = data.multipart else {
            return nil
        }

        return MultipartPart(headers: HTTPHeaders(headers), body: multipart.body)
    }

    public init?(multipart: MultipartPart) {
        guard let filename = multipart.name,
            let data = Data(multipart: multipart) else {
            return nil
        }
        self.filename = filename
        self.data = data

        self.name = multipart.name
        self.mimeType = multipart.headers["Content-Type"].first
    }

    var name: String?
    var filename: String
    var data: Data
    var mimeType: String?
    
    public init(data: Data, name: String? = nil, filename: String, mimeType: String? = nil) {
        self.data = data
        self.name = name
        self.filename = filename
        self.mimeType = mimeType
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(data)
    }
}
