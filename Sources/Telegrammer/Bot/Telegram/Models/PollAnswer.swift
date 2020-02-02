//
//  PollAnswer.swift
//  
//
//  Created by CaptainYukinoshitaHachiman on 2/2/20.
//

/**
 This object contains information about a poll.

 SeeAlso Telegram Bot API Reference:
 [Poll Answer](https://core.telegram.org/bots/api#poll_answer)
 */
public final class PollAnswer: Codable {

    /// Custom keys for coding/decoding `Poll` struct
    enum CodingKeys: String, CodingKey {
        case pollID = "poll_id"
        case user = "user"
        case optionIDs = "option_ids"
    }

    /// Unique poll identifier
    public var pollID: String

    /// The user, who changed the answer to the poll
    public var user: User

    /// 0-based identifiers of answer options, chosen by the user. May be empty if the user retracted their vote.
    public var optionIDs: [Int]


    public init (pollID: String, user: User, optionIDs: [Int]) {
        self.pollID = pollID
        self.user = user
        self.optionIDs = optionIDs
    }

}
