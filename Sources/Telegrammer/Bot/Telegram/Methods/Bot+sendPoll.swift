// Telegrammer - Telegram Bot Swift SDK.
// This file is autogenerated by API/generate_wrappers.rb script.


import HTTP

public extension Bot {

    /// Parameters container struct for `sendPoll` method
    struct SendPollParams: JSONEncodable {

        /// Unique identifier for the target chat or username of the target channel (in the format @channelusername)
        var chatId: ChatId

        /// Poll question, 1-255 characters
        var question: String

        /// A JSON-serialized list of answer options, 2-10 strings 1-100 characters each
        var options: [String]

        /// True, if the poll needs to be anonymous, defaults to True
        var isAnonymous: Bool?

        /// Poll type, “quiz” or “regular”, defaults to “regular”
        var type: String?

        /// True, if the poll allows multiple answers, ignored for polls in quiz mode, defaults to False
        var allowsMultipleAnswers: Bool?

        /// 0-based identifier of the correct answer option, required for polls in quiz mode
        var correctOptionId: Int?

        /// Pass True, if the poll needs to be immediately closed. This can be useful for poll preview.
        var isClosed: Bool?

        /// Sends the message silently. Users will receive a notification with no sound.
        var disableNotification: Bool?

        /// If the message is a reply, ID of the original message
        var replyToMessageId: Int?

        /// Additional interface options. A JSON-serialized object for an inline keyboard, custom reply keyboard, instructions to remove reply keyboard or to force a reply from the user.
        var replyMarkup: ReplyMarkup?

        /// Custom keys for coding/decoding `SendPollParams` struct
        enum CodingKeys: String, CodingKey {
            case chatId = "chat_id"
            case question = "question"
            case options = "options"
            case isAnonymous = "is_anonymous"
            case type = "type"
            case allowsMultipleAnswers = "allows_multiple_answers"
            case correctOptionId = "correct_option_id"
            case isClosed = "is_closed"
            case disableNotification = "disable_notification"
            case replyToMessageId = "reply_to_message_id"
            case replyMarkup = "reply_markup"
        }

        public init(chatId: ChatId, question: String, options: [String], isAnonymous: Bool? = nil, type: String? = nil, allowsMultipleAnswers: Bool? = nil, correctOptionId: Int? = nil, isClosed: Bool? = nil, disableNotification: Bool? = nil, replyToMessageId: Int? = nil, replyMarkup: ReplyMarkup? = nil) {
            self.chatId = chatId
            self.question = question
            self.options = options
            self.isAnonymous = isAnonymous
            self.type = type
            self.allowsMultipleAnswers = allowsMultipleAnswers
            self.correctOptionId = correctOptionId
            self.isClosed = isClosed
            self.disableNotification = disableNotification
            self.replyToMessageId = replyToMessageId
            self.replyMarkup = replyMarkup
        }
    }

    /**
     Use this method to send a native poll. On success, the sent Message is returned.

     SeeAlso Telegram Bot API Reference:
     [SendPollParams](https://core.telegram.org/bots/api#sendpoll)
     
     - Parameters:
         - params: Parameters container, see `SendPollParams` struct
     - Throws: Throws on errors
     - Returns: Future of `Message` type
     */
    @discardableResult
    func sendPoll(params: SendPollParams) throws -> Future<Message> {
        let body = try httpBody(for: params)
        let headers = httpHeaders(for: params)
        let response: Future<TelegramContainer<Message>>
        response = try client.respond(endpoint: "sendPoll", body: body, headers: headers)
        return response.flatMap(to: Message.self) { try self.wrap($0) }
    }
}
