// Telegrammer - Telegram Bot Swift SDK.
// This file is autogenerated by API/generate_wrappers.rb script.

/// This object represent a user's profile pictures.
///
/// [- SeeAlso: ]<https://core.telegram.org/bots/api#userprofilephotos>

public final class UserProfilePhotos: Codable {
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case photos = "photos"
    }

    public var totalCount: Int
    public var photos: [[PhotoSize]]

    public init (totalCount: Int, photos: [[PhotoSize]]) {
        self.totalCount = totalCount
        self.photos = photos
    }

}
