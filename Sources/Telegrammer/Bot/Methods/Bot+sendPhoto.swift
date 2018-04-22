// Telegrammer - Telegram Bot Swift SDK.
// This file is autogenerated by API/generate_wrappers.rb script.


import HTTP

public extension Bot {

    /// Use this method to send photos. On success, the sent Message is returned.
    /// - Parameters:
    ///     - chat_id: Unique identifier for the target chat or username of the target channel (in the format @channelusername)
    ///     - photo: Photo to send. Pass a file_id as String to send a photo that exists on the Telegram servers (recommended), pass an HTTP URL as a String for Telegram to get a photo from the Internet, or upload a new photo using multipart/form-data. More info on Sending Files »
    ///     - caption: Photo caption (may also be used when resending photos by file_id), 0-200 characters
    ///     - parse_mode: Send Markdown or HTML, if you want Telegram apps to show bold, italic, fixed-width text or inline URLs in the media caption.
    ///     - disable_notification: Sends the message silently. Users will receive a notification with no sound.
    ///     - reply_to_message_id: If the message is a reply, ID of the original message
    ///     - reply_markup: Additional interface options. A JSON-serialized object for an inline keyboard, custom reply keyboard, instructions to remove reply keyboard or to force a reply from the user.
    /// - Returns: Future<Message>. Throws on errors.
    /// - Note: Asynchronous method.
    ///
    /// [- SeeAlso: ]<https://core.telegram.org/bots/api#sendphoto>

    public struct SendPhotoParams: MultipartEncodable {
        var chatId: ChatId
        var photo: FileInfo
        var caption: String?
        var parseMode: String?
        var disableNotification: Bool?
        var replyToMessageId: Int?
        var replyMarkup: ReplyMarkup?

        enum CodingKeys: String, CodingKey {
            case chatId = "chat_id"
            case photo = "photo"
            case caption = "caption"
            case parseMode = "parse_mode"
            case disableNotification = "disable_notification"
            case replyToMessageId = "reply_to_message_id"
            case replyMarkup = "reply_markup"
        }

        public init(chatId: ChatId, photo: FileInfo, caption: String? = nil, parseMode: String? = nil, disableNotification: Bool? = nil, replyToMessageId: Int? = nil, replyMarkup: ReplyMarkup? = nil) {
            self.chatId = chatId
            self.photo = photo
            self.caption = caption
            self.parseMode = parseMode
            self.disableNotification = disableNotification
            self.replyToMessageId = replyToMessageId
            self.replyMarkup = replyMarkup
        }
    }

    public func sendPhoto(params: SendPhotoParams) throws -> Future<Message> {
        let body = try httpBody(for: params)
        let headers = try httpHeaders(for: params)
        let response: Future<TelegramContainer<Message>>
        response = try client.respond(endpoint: "sendPhoto", body: body, headers: headers)
        return response.flatMap(to: Message.self) { try self.wrap($0) }
    }
}