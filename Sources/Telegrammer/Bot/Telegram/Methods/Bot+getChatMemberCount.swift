// Telegrammer - Telegram Bot Swift SDK.
// This file is autogenerated by API/generate_wrappers.rb script.

public extension Bot {

    /// Parameters container struct for `getChatMemberCount` method
    struct GetChatMemberCountParams: JSONEncodable {

        /// Unique identifier for the target chat or username of the target supergroup or channel (in the format @channelusername)
        var chatId: ChatId

        /// Custom keys for coding/decoding `GetChatMemberCountParams` struct
        enum CodingKeys: String, CodingKey {
            case chatId = "chat_id"
        }

        public init(chatId: ChatId) {
            self.chatId = chatId
        }
    }

    /**
     Use this method to get the number of members in a chat. Returns Int on success.

     SeeAlso Telegram Bot API Reference:
     [GetChatMemberCountParams](https://core.telegram.org/bots/api#getchatmembercount)
     
     - Parameters:
         - params: Parameters container, see `GetChatMemberCountParams` struct
     - Throws: Throws on errors
     - Returns: Future of `Int` type
     */
    @discardableResult
    func getChatMemberCount(params: GetChatMemberCountParams) throws -> Future<Int> {
        let body = try httpBody(for: params)
        let headers = httpHeaders(for: params)
        return try client
            .request(endpoint: "getChatMemberCount", body: body, headers: headers)
            .flatMapThrowing { (container) -> Int in
                return try self.processContainer(container)
        }
    }
}

// MARK: Concurrency Support
#if compiler(>=5.5)
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public extension Bot {

    /**
     Use this method to get the number of members in a chat. Returns Int on success.

     SeeAlso Telegram Bot API Reference:
     [GetChatMemberCountParams](https://core.telegram.org/bots/api#getchatmembercount)
     
     - Parameters:
         - params: Parameters container, see `GetChatMemberCountParams` struct
     - Throws: Throws on errors
     - Returns: Future of `Int` type
     */
    @discardableResult
    func getChatMemberCount(params: GetChatMemberCountParams) async throws -> Int {
        let body = try httpBody(for: params)
        let headers = httpHeaders(for: params)
        return try self.processContainer(try await client.request(endpoint: "getChatMemberCount", body: body, headers: headers))
    }
}
#endif
