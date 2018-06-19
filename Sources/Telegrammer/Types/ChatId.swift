//
//  ChatId.swift
//  App
//
//  Created by Givi Pataridze on 02.03.2018.
//

import Foundation

/// Unique identifier for the target chat or username of the target channel (in the format @channelusername)
public enum ChatId: Encodable {
	
	case chat(Int64)
	case username(String)
	
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
