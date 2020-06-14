// Telegrammer - Telegram Bot Swift SDK.
// This file is autogenerated by API/generate_wrappers.rb script.

public extension Bot {

    /// Parameters container struct for `sendDocument` method
    struct SendDocumentParams: MultipartEncodable {

        /// Unique identifier for the target chat or username of the target channel (in the format @channelusername)
        var chatId: ChatId

        /// File to send. Pass a file_id as String to send a file that exists on the Telegram servers (recommended), pass an HTTP URL as a String for Telegram to get a file from the Internet, or upload a new one using multipart/form-data. More info on Sending Files »
        var document: FileInfo

        /// Thumbnail of the file sent; can be ignored if thumbnail generation for the file is supported server-side. The thumbnail should be in JPEG format and less than 200 kB in size. A thumbnail's width and height should not exceed 320. Ignored if the file is not uploaded using multipart/form-data. Thumbnails can't be reused and can be only uploaded as a new file, so you can pass “attach://<file_attach_name>” if the thumbnail was uploaded using multipart/form-data under <file_attach_name>. More info on Sending Files »
        var thumb: FileInfo?

        /// Document caption (may also be used when resending documents by file_id), 0-1024 characters after entities parsing
        var caption: String?

        /// Mode for parsing entities in the document caption. See formatting options for more details.
        var parseMode: ParseMode?

        /// Sends the message silently. Users will receive a notification with no sound.
        var disableNotification: Bool?

        /// If the message is a reply, ID of the original message
        var replyToMessageId: Int?

        /// Additional interface options. A JSON-serialized object for an inline keyboard, custom reply keyboard, instructions to remove reply keyboard or to force a reply from the user.
        var replyMarkup: ReplyMarkup?

        /// Custom keys for coding/decoding `SendDocumentParams` struct
        enum CodingKeys: String, CodingKey {
            case chatId = "chat_id"
            case document = "document"
            case thumb = "thumb"
            case caption = "caption"
            case parseMode = "parse_mode"
            case disableNotification = "disable_notification"
            case replyToMessageId = "reply_to_message_id"
            case replyMarkup = "reply_markup"
        }

        public init(chatId: ChatId, document: FileInfo, thumb: FileInfo? = nil, caption: String? = nil, parseMode: ParseMode? = nil, disableNotification: Bool? = nil, replyToMessageId: Int? = nil, replyMarkup: ReplyMarkup? = nil) {
            self.chatId = chatId
            self.document = document
            self.thumb = thumb
            self.caption = caption
            self.parseMode = parseMode
            self.disableNotification = disableNotification
            self.replyToMessageId = replyToMessageId
            self.replyMarkup = replyMarkup
        }
    }

    /**
     Use this method to send general files. On success, the sent Message is returned. Bots can currently send files of any type of up to 50 MB in size, this limit may be changed in the future.

     SeeAlso Telegram Bot API Reference:
     [SendDocumentParams](https://core.telegram.org/bots/api#senddocument)
     
     - Parameters:
         - params: Parameters container, see `SendDocumentParams` struct
     - Throws: Throws on errors
     - Returns: Future of `Message` type
     */
    @discardableResult
    func sendDocument(params: SendDocumentParams) throws -> Future<Message> {
        let body = try httpBody(for: params)
        let headers = httpHeaders(for: params)
        return try client
            .request(endpoint: "sendDocument", body: body, headers: headers)
            .flatMapThrowing { (container) -> Message in
                return try self.processContainer(container)
        }
    }
}
