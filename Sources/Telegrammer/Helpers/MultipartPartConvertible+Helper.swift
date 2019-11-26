//
//  MultipartPartConvertible+Helper.swift
//  Telegrammer
//
//  Created by Givi on 11/03/2019.
//

import Foundation
import MultipartKit

public protocol MultipartPartNestedConvertible: MultipartPartConvertible {}

public extension MultipartPartNestedConvertible where Self: Codable {
    func convertToMultipartPart() throws -> MultipartPart {
        let data = try JSONEncoder().encode(self)
        return MultipartPart(body: data)
    }

    init?(multipart: MultipartPart) {
        guard let bytes = multipart.body.getBytes(
            at: 0,
            length: multipart.body.writerIndex
            ) else {
                return nil
        }

        do {
            self = try JSONDecoder().decode(Self.self, from: Data(bytes))
        } catch {
            log.error(error.logMessage)
            return nil
        }
    }

    var multipart: MultipartPart? {
        do {
            let data = try JSONEncoder().encode(self)
            return MultipartPart(body: data)
        } catch {
            log.error(error.logMessage)
            return nil
        }
    }

    static func convertFromMultipartPart(_ part: MultipartPart) throws -> Self {
        guard let bytes = part.body.getBytes(at: 0, length: part.body.writerIndex) else {
            throw MultipartError.invalidFormat
        }
        return try JSONDecoder().decode(self.self, from: Data(bytes) )
    }
}
