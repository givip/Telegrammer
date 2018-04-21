//
//  ReplyMarkup.swift
//  App
//
//  Created by Givi Pataridze on 01.03.2018.
//

public enum ReplyMarkup: Codable {
	case inlineKeyboardMarkup(InlineKeyboardMarkup)
	case replyKeyboardMarkup(ReplyKeyboardMarkup)
	case replyKeyboardRemove(ReplyKeyboardRemove)
	case forceReply(ForceReply)
	case undefined
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		switch self {
		case .inlineKeyboardMarkup(let value):
			try container.encode(value)
		case .replyKeyboardMarkup(let value):
			try container.encode(value)
		case .replyKeyboardRemove(let value):
			try container.encode(value)
		case .forceReply(let value):
			try container.encode(value)
		case .undefined:
			try container.encodeNil()
		}
	}
	
	public init(from decoder: Decoder) throws {
		if let value = try? decoder.singleValueContainer().decode(InlineKeyboardMarkup.self) {
			self = ReplyMarkup.inlineKeyboardMarkup(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(ReplyKeyboardMarkup.self) {
			self = ReplyMarkup.replyKeyboardMarkup(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(ReplyKeyboardRemove.self) {
			self = ReplyMarkup.replyKeyboardRemove(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(ForceReply.self) {
			self = ReplyMarkup.forceReply(value)
			return
		}
		self = ReplyMarkup.undefined
	}
}
