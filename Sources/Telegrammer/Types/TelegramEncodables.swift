//
//  TelegramEncodables.swift
//  App
//
//  Created by Givi Pataridze on 07.04.2018.
//

import Foundation
import Multipart

protocol JSONEncodable: Encodable {}

extension JSONEncodable {    
	func encodeBody() throws -> Data {
		return try JSONEncoder().encode(self)
	}
}

protocol MultipartEncodable: Encodable {}

extension MultipartEncodable {
	func encodeBody(boundary: [UInt8]) throws -> Data {
		return try FormDataEncoder().encode(self, boundary: boundary)
	}
}
