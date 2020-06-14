// Telegrammer - Telegram Bot Swift SDK.
// This file is autogenerated by API/generate_wrappers.rb script.

public extension Bot {

    /// Parameters container struct for `getUserProfilePhotos` method
    struct GetUserProfilePhotosParams: JSONEncodable {

        /// Unique identifier of the target user
        var userId: Int64

        /// Sequential number of the first photo to be returned. By default, all photos are returned.
        var offset: Int?

        /// Limits the number of photos to be retrieved. Values between 1-100 are accepted. Defaults to 100.
        var limit: Int?

        /// Custom keys for coding/decoding `GetUserProfilePhotosParams` struct
        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
            case offset = "offset"
            case limit = "limit"
        }

        public init(userId: Int64, offset: Int? = nil, limit: Int? = nil) {
            self.userId = userId
            self.offset = offset
            self.limit = limit
        }
    }

    /**
     Use this method to get a list of profile pictures for a user. Returns a UserProfilePhotos object.

     SeeAlso Telegram Bot API Reference:
     [GetUserProfilePhotosParams](https://core.telegram.org/bots/api#getuserprofilephotos)
     
     - Parameters:
         - params: Parameters container, see `GetUserProfilePhotosParams` struct
     - Throws: Throws on errors
     - Returns: Future of `UserProfilePhotos` type
     */
    @discardableResult
    func getUserProfilePhotos(params: GetUserProfilePhotosParams) throws -> Future<UserProfilePhotos> {
        let body = try httpBody(for: params)
        let headers = httpHeaders(for: params)
        return try client
            .request(endpoint: "getUserProfilePhotos", body: body, headers: headers)
            .flatMapThrowing { (container) -> UserProfilePhotos in
                return try self.processContainer(container)
        }
    }
}
