//
//  InputFile.swift
//  App
//
//  Created by Givi Pataridze on 28.02.2018.
//

import Foundation
import MultipartKit

/**
 This object represents the contents of a file to be uploaded. Must be posted using multipart/form-data in the usual way that files are uploaded via the browser.
 
 SeeAlso Telegram Bot API Reference:
 [Input Files](https://core.telegram.org/bots/api#inputfile)
 */
public struct InputFile: Encodable, MultipartPartConvertible {
    
    public func convertToMultipartPart() throws -> MultipartPart {
        var headers: [CaseInsensitiveString : String] = [:]
        
        var nameStr = ""
        if let name = name {
            nameStr = "; name=\"\(name)\""
        }
        
        headers["Content-Disposition"] = "form-data\(nameStr); filename=\"\(filename)\""
        
        if let mime = mimeType {
            headers["Content-Type"] = "\(mime)"
        }
        
        return MultipartPart(data: data, headers: headers)
    }
    
    public static func convertFromMultipartPart(_ part: MultipartPart) throws -> InputFile {
        guard let filename = part.filename else {
            throw MultipartError(identifier: "convertible", reason: "Telegram server doesn't accept files without filename header.")
        }
        return  InputFile(data: part.data, name: part.name, filename: filename, mimeType: part.contentType?.serialize())
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
