// Telegrammer - Telegram Bot Swift SDK.
// This file is autogenerated by API/generate_wrappers.rb script.

public extension Bot {

    /**
     Use this method to get current webhook status. Requires no parameters. On success, returns a WebhookInfo object. If the bot is using getUpdates, will return an object with the url field empty.

     SeeAlso Telegram Bot API Reference:
     [GetWebhookInfoParams](https://core.telegram.org/bots/api#getwebhookinfo)
     
     - Parameters:
         - params: Parameters container, see `GetWebhookInfoParams` struct
     - Throws: Throws on errors
     - Returns: Future of `WebhookInfo` type
     */
    @discardableResult
    func getWebhookInfo() throws -> Future<WebhookInfo> {
        return try client
            .request(endpoint: "getWebhookInfo")
            .flatMapThrowing { (container) -> WebhookInfo in
                return try self.processContainer(container)
        }
    }
}

// MARK: Concurrency Support
#if compiler(>=5.5)
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public extension Bot {

    /**
     Use this method to get current webhook status. Requires no parameters. On success, returns a WebhookInfo object. If the bot is using getUpdates, will return an object with the url field empty.

     SeeAlso Telegram Bot API Reference:
     [GetWebhookInfoParams](https://core.telegram.org/bots/api#getwebhookinfo)
     
     - Parameters:
         - params: Parameters container, see `GetWebhookInfoParams` struct
     - Throws: Throws on errors
     - Returns: Future of `WebhookInfo` type
     */
    @discardableResult
    func getWebhookInfo() async throws -> WebhookInfo {
        return try self.processContainer(try await client.request(endpoint: "getWebhookInfo"))
    }
}
#endif
