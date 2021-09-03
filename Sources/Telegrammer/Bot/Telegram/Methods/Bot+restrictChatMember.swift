// Telegrammer - Telegram Bot Swift SDK.
// This file is autogenerated by API/generate_wrappers.rb script.

public extension Bot {

    /// Parameters container struct for `restrictChatMember` method
    struct RestrictChatMemberParams: JSONEncodable {

        /// Unique identifier for the target chat or username of the target supergroup (in the format @supergroupusername)
        var chatId: ChatId

        /// Unique identifier of the target user
        var userId: Int64

        /// A JSON-serialized object for new user permissions
        var permissions: ChatPermissions

        /// Date when restrictions will be lifted for the user, unix time. If user is restricted for more than 366 days or less than 30 seconds from the current time, they are considered to be restricted forever
        var untilDate: Int?

        /// Custom keys for coding/decoding `RestrictChatMemberParams` struct
        enum CodingKeys: String, CodingKey {
            case chatId = "chat_id"
            case userId = "user_id"
            case permissions = "permissions"
            case untilDate = "until_date"
        }

        public init(chatId: ChatId, userId: Int64, permissions: ChatPermissions, untilDate: Int? = nil) {
            self.chatId = chatId
            self.userId = userId
            self.permissions = permissions
            self.untilDate = untilDate
        }
    }

    /**
     Use this method to restrict a user in a supergroup. The bot must be an administrator in the supergroup for this to work and must have the appropriate admin rights. Pass True for all permissions to lift restrictions from a user. Returns True on success.

     SeeAlso Telegram Bot API Reference:
     [RestrictChatMemberParams](https://core.telegram.org/bots/api#restrictchatmember)
     
     - Parameters:
         - params: Parameters container, see `RestrictChatMemberParams` struct
     - Throws: Throws on errors
     - Returns: Future of `Bool` type
     */
    @discardableResult
    func restrictChatMember(params: RestrictChatMemberParams) throws -> Future<Bool> {
        let body = try httpBody(for: params)
        let headers = httpHeaders(for: params)
        return try client
            .request(endpoint: "restrictChatMember", body: body, headers: headers)
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
     Use this method to restrict a user in a supergroup. The bot must be an administrator in the supergroup for this to work and must have the appropriate admin rights. Pass True for all permissions to lift restrictions from a user. Returns True on success.

     SeeAlso Telegram Bot API Reference:
     [RestrictChatMemberParams](https://core.telegram.org/bots/api#restrictchatmember)
     
     - Parameters:
         - params: Parameters container, see `RestrictChatMemberParams` struct
     - Throws: Throws on errors
     - Returns: Future of `Bool` type
     */
    @discardableResult
    func restrictChatMember(params: RestrictChatMemberParams) async throws -> Bool {
        let body = try httpBody(for: params)
        let headers = httpHeaders(for: params)
        return try self.processContainer(try await client.request(endpoint: "restrictChatMember", body: body, headers: headers))
    }
}
#endif
