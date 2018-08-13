//
//  InlineQueryResult.swift
//  App
//
//  Created by Givi Pataridze on 28.02.2018.
//


/// This enum represents one result of an inline query. Telegram clients currently support results of the following 20 types
public enum InlineQueryResult: Codable {
	case cachedAudio(InlineQueryResultAudio)
	case cachedDocument(InlineQueryResultCachedDocument)
	case cachedGif(InlineQueryResultCachedGif)
	case cachedMpeg4Gif(InlineQueryResultCachedMpeg4Gif)
	case cachedPhoto(InlineQueryResultCachedPhoto)
	case cachedSticker(InlineQueryResultCachedSticker)
	case cachedVideo(InlineQueryResultCachedVideo)
	case cachedVoice(InlineQueryResultCachedVoice)
	case article(InlineQueryResultArticle)
	case audio(InlineQueryResultAudio)
	case contact(InlineQueryResultContact)
	case game(InlineQueryResultGame)
	case document(InlineQueryResultDocument)
	case gif(InlineQueryResultGif)
	case location(InlineQueryResultLocation)
	case mpeg4Gif(InlineQueryResultMpeg4Gif)
	case photo(InlineQueryResultPhoto)
	case venue(InlineQueryResultVenue)
	case video(InlineQueryResultVideo)
	case voice(InlineQueryResultVoice)
	case undefined
	
	
	public init(from decoder: Decoder) throws {
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultAudio.self) {
			self = .cachedAudio(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultCachedDocument.self) {
			self = .cachedDocument(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultCachedGif.self) {
			self = .cachedGif(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultCachedMpeg4Gif.self) {
			self = .cachedMpeg4Gif(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultCachedPhoto.self) {
			self = .cachedPhoto(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultCachedSticker.self) {
			self = .cachedSticker(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultCachedVideo.self) {
			self = .cachedVideo(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultCachedVoice.self) {
			self = .cachedVoice(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultArticle.self) {
			self = .article(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultAudio.self) {
			self = .audio(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultContact.self) {
			self = .contact(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultGame.self) {
			self = .game(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultDocument.self) {
			self = .document(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultGif.self) {
			self = .gif(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultLocation.self) {
			self = .location(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultMpeg4Gif.self) {
			self = .mpeg4Gif(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultPhoto.self) {
			self = .photo(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultVenue.self) {
			self = .venue(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultVideo.self) {
			self = .video(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultVoice.self) {
			self = .voice(value)
			return
		}
		self = .undefined
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		switch self {
		case .cachedAudio(let value):
			try container.encode(value)
		case .cachedDocument(let value):
			try container.encode(value)
		case .cachedGif(let value):
			try container.encode(value)
		case .cachedMpeg4Gif(let value):
			try container.encode(value)
		case .cachedPhoto(let value):
			try container.encode(value)
		case .cachedSticker(let value):
			try container.encode(value)
		case .cachedVideo(let value):
			try container.encode(value)
		case .cachedVoice(let value):
			try container.encode(value)
		case .article(let value):
			try container.encode(value)
		case .audio(let value):
			try container.encode(value)
		case .contact(let value):
			try container.encode(value)
		case .game(let value):
			try container.encode(value)
		case .document(let value):
			try container.encode(value)
		case .gif(let value):
			try container.encode(value)
		case .location(let value):
			try container.encode(value)
		case .mpeg4Gif(let value):
			try container.encode(value)
		case .photo(let value):
			try container.encode(value)
		case .venue(let value):
			try container.encode(value)
		case .video(let value):
			try container.encode(value)
		case .voice(let value):
			try container.encode(value)
		case .undefined:
			try container.encodeNil()
		}
	}
}
