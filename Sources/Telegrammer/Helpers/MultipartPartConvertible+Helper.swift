//
//  MultipartPartConvertible+Helper.swift
//  Telegrammer
//
//  Created by Givi on 11/03/2019.
//

import Foundation
import TelegrammerMultipart

public extension MultipartPartConvertible where Self: Codable {
    init?(multipart: MultipartPart) {
        guard let data = Data(multipart: multipart) else {
            return nil
        }

        do {
            self = try JSONDecoder().decode(Self.self, from: data)
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
