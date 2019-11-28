// Telegrammer - Telegram Bot Swift SDK.
// This file is autogenerated by API/generate_wrappers.rb script.



public extension Bot {

    /// Parameters container struct for `getFile` method
    struct GetFileParams: JSONEncodable {

        /// File identifier to get info about
        var fileId: String

        /// Custom keys for coding/decoding `GetFileParams` struct
        enum CodingKeys: String, CodingKey {
            case fileId = "file_id"
        }

        public init(fileId: String) {
            self.fileId = fileId
        }
    }

    /**
     Use this method to get basic info about a file and prepare it for downloading. For the moment, bots can download files of up to 20MB in size. On success, a File object is returned. The file can then be downloaded via the link https://api.telegram.org/file/bot<token>/<file_path>, where <file_path> is taken from the response. It is guaranteed that the link will be valid for at least 1 hour. When the link expires, a new one can be requested by calling getFile again.

     SeeAlso Telegram Bot API Reference:
     [GetFileParams](https://core.telegram.org/bots/api#getfile)
     
     - Parameters:
         - params: Parameters container, see `GetFileParams` struct
     - Throws: Throws on errors
     - Returns: Future of `File` type
     */
    @discardableResult
    func getFile(params: GetFileParams) throws -> Future<File> {
        let body = try httpBody(for: params)
        let headers = httpHeaders(for: params)
        return try client
            .request(endpoint: "getFile", body: body, headers: headers)
            .flatMapThrowing { (container) -> File in
                return try self.processContainer(container)
        }
    }
}
