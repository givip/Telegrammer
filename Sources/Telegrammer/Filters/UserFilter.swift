//
//  UserFilter.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

public struct UserFilter: Filter {
    
    var userIds: Set<Int64>?
    var usernames: Set<String>?
    
    public init(userId: Int64) {
        self.userIds = Set<Int64>([userId])
    }
    
    public init(username: String) {
        self.usernames = Set<String>([username])
    }
    
    public init(userIds: [Int64]) {
        self.userIds = Set(userIds)
    }
    
    public init(usernames: [String]) {
        self.usernames = Set(usernames)
    }
    
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
