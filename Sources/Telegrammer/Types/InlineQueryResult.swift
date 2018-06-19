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
			self = InlineQueryResult.cachedAudio(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultCachedDocument.self) {
			self = InlineQueryResult.cachedDocument(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultCachedGif.self) {
			self = InlineQueryResult.cachedGif(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultCachedMpeg4Gif.self) {
			self = InlineQueryResult.cachedMpeg4Gif(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultCachedPhoto.self) {
			self = InlineQueryResult.cachedPhoto(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultCachedSticker.self) {
			self = InlineQueryResult.cachedSticker(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultCachedVideo.self) {
			self = InlineQueryResult.cachedVideo(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultCachedVoice.self) {
			self = InlineQueryResult.cachedVoice(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultArticle.self) {
			self = InlineQueryResult.article(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultAudio.self) {
			self = InlineQueryResult.audio(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultContact.self) {
			self = InlineQueryResult.contact(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultGame.self) {
			self = InlineQueryResult.game(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultDocument.self) {
			self = InlineQueryResult.document(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultGif.self) {
			self = InlineQueryResult.gif(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultLocation.self) {
			self = InlineQueryResult.location(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultMpeg4Gif.self) {
			self = InlineQueryResult.mpeg4Gif(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultPhoto.self) {
			self = InlineQueryResult.photo(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultVenue.self) {
			self = InlineQueryResult.venue(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultVideo.self) {
			self = InlineQueryResult.video(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(InlineQueryResultVoice.self) {
			self = InlineQueryResult.voice(value)
			return
		}
		self = InlineQueryResult.undefined
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
