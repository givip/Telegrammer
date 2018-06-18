//
//  UserFilter.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

/// Filters messages to allow only those which are from specified user ID.
public struct UserFilter: Filter {
    
    var userIds: Set<Int64>?
    var usernames: Set<String>?
    
    /**
     Init filter with user id
     */
    public init(userId: Int64) {
        self.userIds = Set<Int64>([userId])
    }
    
    /**
      Init filter which username to allow through.
     
      Note: Which username to allow through. If username starts with ‘@’ symbol, it will be ignored.
     */
    public init(username: String) {
        self.usernames = Set<String>([username])
    }
    
    /**
     Init filter with user ids
     */
    public init(userIds: [Int64]) {
        self.userIds = Set(userIds)
    }
    
    /**
     Init filter which usernames to allow through.
     
     Note: If username starts with ‘@’ symbol, it will be ignored.
     */
    public init(usernames: [String]) {
        self.usernames = Set(usernames)
    }
    
    /**
     Init filter with user id or user name
     
     Note: If username starts with ‘@’ symbol, it will be ignored.
     */
    public init(userIds: [Int64], usernames: [String]) {
        self.userIds = Set(userIds)
        self.usernames = Set(usernames)
    }
    
    public var name: String = "user"
    
    public func filter(message: Message) -> Bool {
        guard let user = message.from else { return false }
        
        if let ids = userIds,
            !ids.contains(user.id) {
            return false
        }
        
        if let names = usernames,
            let username = user.username,
            !names.contains(username) {
            return false
        }
        
        return true
    }
}

public extension Filters {
    static func user(userId: Int64) -> Filters {
        return Filters(filter: UserFilter(userId: userId))
    }
    
    static func user(username: String) -> Filters {
        return Filters(filter: UserFilter(username: username))
    }
    
    static func user(userIds: [Int64]) -> Filters {
        return Filters(filter: UserFilter(userIds: userIds))
    }
    
    static func user(usernames: [String]) -> Filters {
        return Filters(filter: UserFilter(usernames: usernames))
    }
    
    static func user(userIds: [Int64], usernames: [String]) -> Filters {
        return Filters(filter: UserFilter(userIds: userIds, usernames: usernames))
    }
}
