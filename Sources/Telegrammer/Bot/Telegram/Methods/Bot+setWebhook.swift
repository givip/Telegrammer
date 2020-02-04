// Telegrammer - Telegram Bot Swift SDK.
// This file is autogenerated by API/generate_wrappers.rb script.



public extension Bot {

    /// Parameters container struct for `setWebhook` method
    struct SetWebhookParams: MultipartEncodable {

        /// HTTPS url to send updates to. Use an empty string to remove webhook integration
        var url: String

        /// Upload your public key certificate so that the root certificate in use can be checked. See our self-signed guide for details.
        var certificate: InputFile?

        /// Maximum allowed number of simultaneous HTTPS connections to the webhook for update delivery, 1-100. Defaults to 40. Use lower values to limit the load on your bot‘s server, and higher values to increase your bot’s throughput.
        var maxConnections: Int?

        /// A JSON-serialized list of the update types you want your bot to receive. For example, specify [“message”, “edited_channel_post”, “callback_query”] to only receive updates of these types. See Update for a complete list of available update types. Specify an empty list to receive all updates regardless of type (default). If not specified, the previous setting will be used.
        /// 
        /// Please note that this parameter doesn't affect updates created before the call to the setWebhook, so unwanted updates may be received for a short period of time.
        var allowedUpdates: [String]?

        /// Custom keys for coding/decoding `SetWebhookParams` struct
        enum CodingKeys: String, CodingKey {
            case url = "url"
            case certificate = "certificate"
            case maxConnections = "max_connections"
            case allowedUpdates = "allowed_updates"
        }

        public init(url: String, certificate: InputFile? = nil, maxConnections: Int? = nil, allowedUpdates: [String]? = nil) {
            self.url = url
            self.certificate = certificate
            self.maxConnections = maxConnections
            self.allowedUpdates = allowedUpdates
        }
    }

    /**
     Use this method to specify a url and receive incoming updates via an outgoing webhook. Whenever there is an update for the bot, we will send an HTTPS POST request to the specified url, containing a JSON-serialized Update. In case of an unsuccessful request, we will give up after a reasonable amount of attempts. Returns True on success.
     If you'd like to make sure that the Webhook request comes from Telegram, we recommend using a secret path in the URL, e.g. https://www.example.com/<token>. Since nobody else knows your bot‘s token, you can be pretty sure it’s us.

     SeeAlso Telegram Bot API Reference:
     [SetWebhookParams](https://core.telegram.org/bots/api#setwebhook)
     
     - Parameters:
         - params: Parameters container, see `SetWebhookParams` struct
     - Throws: Throws on errors
     - Returns: Future of `Bool` type
     */
    @discardableResult
    func setWebhook(params: SetWebhookParams) throws -> Future<Bool> {
        let body = try httpBody(for: params)
        let headers = httpHeaders(for: params)
        return try client
            .request(endpoint: "setWebhook", body: body, headers: headers)
            .flatMapThrowing { (container) -> Bool in
                return try self.processContainer(container)
        }
    }
}
