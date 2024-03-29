// Telegrammer - Telegram Bot Swift SDK.
// This file is autogenerated by API/generate_wrappers.rb script.

/**
 Represents a location to which a chat is connected.

 SeeAlso Telegram Bot API Reference:
 [ChatLocation](https://core.telegram.org/bots/api#chatlocation)
 */
public final class ChatLocation: Codable {

    /// Custom keys for coding/decoding `ChatLocation` struct
    enum CodingKeys: String, CodingKey {
        case location = "location"
        case address = "address"
    }

    /// The location to which the supergroup is connected. Can't be a live location.
    public var location: Location

    /// Location address; 1-64 characters, as defined by the chat owner
    public var address: String

    public init (location: Location, address: String) {
        self.location = location
        self.address = address
    }
}
