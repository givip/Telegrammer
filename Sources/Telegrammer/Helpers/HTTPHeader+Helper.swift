//
//  HTTPHeader+Helper.swift
//  App
//
//  Created by Givi Pataridze on 26.02.2018.
//

import AsyncHTTPClient
import NIOHTTP1

extension HTTPHeaders {
    static var contentJson: HTTPHeaders {
        return HTTPHeaders([("Content-Type", "application/json")])
    }

    static func typeFormData(boundary: String, length: Int? = nil) -> HTTPHeaders {
        return HTTPHeaders([("Content-Type", "multipart/form-data; boundary=\(boundary)")])
    }

    static func dispositionFormData(name: String) -> HTTPHeaders {
        return HTTPHeaders([("Content-Disposition", "form-data; name=\"\(name)\"")])
    }

    static func dispositionFormDataFile(name: String, fileName: String? = nil, mime: String? = nil) -> HTTPHeaders {

        var fileNameStr = ""
        if let fileName = fileName {
            fileNameStr = "; filename=\"\(fileName)\""
        }

        var headers = [("Content-Disposition", "form-data; name=\"\(name)\"\(fileNameStr)")]

        if let mime = mime {
            headers.append(("Content-Type", "\(mime)"))
        }

        return HTTPHeaders(headers)
    }

    static var empty: HTTPHeaders {
        return HTTPHeaders()
    }
}
