// Telegrammer - Telegram Bot Swift SDK.
// This file is autogenerated by API/generate_wrappers.rb script.

public extension Bot {

    /// Parameters container struct for `answerPreCheckoutQuery` method
    struct AnswerPreCheckoutQueryParams: JSONEncodable {

        /// Unique identifier for the query to be answered
        var preCheckoutQueryId: String

        /// Specify True if everything is alright (goods are available, etc.) and the bot is ready to proceed with the order. Use False if there are any problems.
        var ok: Bool

        /// Required if ok is False. Error message in human readable form that explains the reason for failure to proceed with the checkout (e.g. "Sorry, somebody just bought the last of our amazing black T-shirts while you were busy filling out your payment details. Please choose a different color or garment!"). Telegram will display this message to the user.
        var errorMessage: String?

        /// Custom keys for coding/decoding `AnswerPreCheckoutQueryParams` struct
        enum CodingKeys: String, CodingKey {
            case preCheckoutQueryId = "pre_checkout_query_id"
            case ok = "ok"
            case errorMessage = "error_message"
        }

        public init(preCheckoutQueryId: String, ok: Bool, errorMessage: String? = nil) {
            self.preCheckoutQueryId = preCheckoutQueryId
            self.ok = ok
            self.errorMessage = errorMessage
        }
    }

    /**
     Once the user has confirmed their payment and shipping details, the Bot API sends the final confirmation in the form of an Update with the field pre_checkout_query. Use this method to respond to such pre-checkout queries. On success, True is returned. Note: The Bot API must receive an answer within 10 seconds after the pre-checkout query was sent.

     SeeAlso Telegram Bot API Reference:
     [AnswerPreCheckoutQueryParams](https://core.telegram.org/bots/api#answerprecheckoutquery)
     
     - Parameters:
         - params: Parameters container, see `AnswerPreCheckoutQueryParams` struct
     - Throws: Throws on errors
     - Returns: Future of `Bool` type
     */
    @discardableResult
    func answerPreCheckoutQuery(params: AnswerPreCheckoutQueryParams) throws -> Future<Bool> {
        let body = try httpBody(for: params)
        let headers = httpHeaders(for: params)
        return try client
            .request(endpoint: "answerPreCheckoutQuery", body: body, headers: headers)
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
     Once the user has confirmed their payment and shipping details, the Bot API sends the final confirmation in the form of an Update with the field pre_checkout_query. Use this method to respond to such pre-checkout queries. On success, True is returned. Note: The Bot API must receive an answer within 10 seconds after the pre-checkout query was sent.

     SeeAlso Telegram Bot API Reference:
     [AnswerPreCheckoutQueryParams](https://core.telegram.org/bots/api#answerprecheckoutquery)
     
     - Parameters:
         - params: Parameters container, see `AnswerPreCheckoutQueryParams` struct
     - Throws: Throws on errors
     - Returns: Future of `Bool` type
     */
    @discardableResult
    func answerPreCheckoutQuery(params: AnswerPreCheckoutQueryParams) async throws -> Bool {
        let body = try httpBody(for: params)
        let headers = httpHeaders(for: params)
        return try self.processContainer(try await client.request(endpoint: "answerPreCheckoutQuery", body: body, headers: headers))
    }
}
#endif
