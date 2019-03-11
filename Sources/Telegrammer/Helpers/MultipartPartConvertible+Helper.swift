//
//  MultipartPartConvertible+Helper.swift
//  Telegrammer
//
//  Created by Givi on 11/03/2019.
//

import Foundation
import Multipart

public protocol MultipartPartNestedConvertible: MultipartPartConvertible {}

public extension MultipartPartNestedConvertible where Self: Codable {
    func convertToMultipartPart() throws -> MultipartPart {
        return try MultipartPart(data: JSONEncoder().encode(self))
    }

    static func convertFromMultipartPart(_ part: MultipartPart) throws -> Self {
        do {
            return try JSONDecoder().decode(self.self, from: part.data)
        } catch {
            throw MultipartError(
                identifier: "\(self.self)",
                reason: "Failed to setup instance from json decoder - \(error)"
            )
        }
    }
}
