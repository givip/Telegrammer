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
}
