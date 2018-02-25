//
//  ChatId.swift
//  App
//
//  Created by Givi Pataridze on 02.03.2018.
//

import Foundation

public enum ChatId: Uploadable {
	
	case chat(Int64)
	case username(String)
	
	var data: Data {
		switch self {
		case .chat(let chat):
			return "\(chat)".convertToData()
		case .username(let username):
			return username.convertToData()
		}
	}
	
	var filename: String? {
		return nil
	}
	
	var mimeType: String? {
		return nil
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		switch self {
		case .username(let string):
			try container.encode(string)
		case .chat(let integer):
			try container.encode(integer)
		}
	}
}
