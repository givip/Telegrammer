//
//  TelegramContainer.swift
//  App
//
//  Created by Givi Pataridze on 25.02.2018.
//

/// This object represents a Telegram response container.
///

public struct TelegramContainer<T: Codable>: Codable {
	
	enum CodingKeys: String, CodingKey {
		case ok = "ok"
		case result = "result"
		case description = "description"
		case errorCode = "error_code"
	}
	
	public var ok: Bool
	public var result: T?
	public var description: String?
	public var errorCode: Int?
	
	public init (ok: Bool, result: T?, description: String?, errorCode: Int?) {
		self.ok = ok
		self.result = result
		self.description = description
		self.errorCode = errorCode
	}
	
}


