// Telegrammer - Telegram Bot Swift SDK.
// This file is autogenerated by API/generate_wrappers.rb script.

public extension Bot {

    /// Parameters container struct for `setStickerPositionInSet` method
    struct SetStickerPositionInSetParams: JSONEncodable {

        /// File identifier of the sticker
        var sticker: String

        /// New sticker position in the set, zero-based
        var position: Int

        /// Custom keys for coding/decoding `SetStickerPositionInSetParams` struct
        enum CodingKeys: String, CodingKey {
            case sticker = "sticker"
            case position = "position"
        }

        public init(sticker: String, position: Int) {
            self.sticker = sticker
            self.position = position
        }
    }

    /**
     Use this method to move a sticker in a set created by the bot to a specific position. Returns True on success.

     SeeAlso Telegram Bot API Reference:
     [SetStickerPositionInSetParams](https://core.telegram.org/bots/api#setstickerpositioninset)
     
     - Parameters:
         - params: Parameters container, see `SetStickerPositionInSetParams` struct
     - Throws: Throws on errors
     - Returns: Future of `Bool` type
     */
    @discardableResult
    func setStickerPositionInSet(params: SetStickerPositionInSetParams) throws -> Future<Bool> {
        let body = try httpBody(for: params)
        let headers = httpHeaders(for: params)
        return try client
            .request(endpoint: "setStickerPositionInSet", body: body, headers: headers)
            .flatMapThrowing { (container) -> Bool in
                return try self.processContainer(container)
        }
    }
}

// MARK: Concurrency Support
#if compiler(>=5.5)
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public extension Bot {

    /**
     Use this method to move a sticker in a set created by the bot to a specific position. Returns True on success.

     SeeAlso Telegram Bot API Reference:
     [SetStickerPositionInSetParams](https://core.telegram.org/bots/api#setstickerpositioninset)
     
     - Parameters:
         - params: Parameters container, see `SetStickerPositionInSetParams` struct
     - Throws: Throws on errors
     - Returns: Future of `Bool` type
     */
    @discardableResult
    func setStickerPositionInSet(params: SetStickerPositionInSetParams) async throws -> Bool {
        let body = try httpBody(for: params)
        let headers = httpHeaders(for: params)
        return try self.processContainer(try await client.request(endpoint: "setStickerPositionInSet", body: body, headers: headers))
    }
}
#endif
