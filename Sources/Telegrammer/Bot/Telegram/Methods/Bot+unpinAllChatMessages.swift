// Telegrammer - Telegram Bot Swift SDK.
// This file is autogenerated by API/generate_wrappers.rb script.

public extension Bot {

    /// Parameters container struct for `unpinAllChatMessages` method
    struct UnpinAllChatMessagesParams: JSONEncodable {

        /// Unique identifier for the target chat or username of the target channel (in the format @channelusername)
        var chatId: ChatId

        /// Custom keys for coding/decoding `UnpinAllChatMessagesParams` struct
        enum CodingKeys: String, CodingKey {
            case chatId = "chat_id"
        }

        public init(chatId: ChatId) {
            self.chatId = chatId
        }
    }

    /**
     Use this method to clear the list of pinned messages in a chat. If the chat is not a private chat, the bot must be an administrator in the chat for this to work and must have the 'can_pin_messages' admin right in a supergroup or 'can_edit_messages' admin right in a channel. Returns True on success.

     SeeAlso Telegram Bot API Reference:
     [UnpinAllChatMessagesParams](https://core.telegram.org/bots/api#unpinallchatmessages)
     
     - Parameters:
         - params: Parameters container, see `UnpinAllChatMessagesParams` struct
     - Throws: Throws on errors
     - Returns: Future of `Bool` type
     */
    @discardableResult
    func unpinAllChatMessages(params: UnpinAllChatMessagesParams) throws -> Future<Bool> {
        let body = try httpBody(for: params)
        let headers = httpHeaders(for: params)
        return try client
            .request(endpoint: "unpinAllChatMessages", body: body, headers: headers)
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
     Use this method to clear the list of pinned messages in a chat. If the chat is not a private chat, the bot must be an administrator in the chat for this to work and must have the 'can_pin_messages' admin right in a supergroup or 'can_edit_messages' admin right in a channel. Returns True on success.

     SeeAlso Telegram Bot API Reference:
     [UnpinAllChatMessagesParams](https://core.telegram.org/bots/api#unpinallchatmessages)
     
     - Parameters:
         - params: Parameters container, see `UnpinAllChatMessagesParams` struct
     - Throws: Throws on errors
     - Returns: Future of `Bool` type
     */
    @discardableResult
    func unpinAllChatMessages(params: UnpinAllChatMessagesParams) async throws -> Bool {
        let body = try httpBody(for: params)
        let headers = httpHeaders(for: params)
        return try self.processContainer(try await client.request(endpoint: "unpinAllChatMessages", body: body, headers: headers))
    }
}
#endif