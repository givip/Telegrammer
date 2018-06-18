//
//  StatusUpdateFilters.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

/**
 Subset struct for messages containing a status update.
 
 Use these filters like: `StatusUpdateFilters.newChatMembers` etc.
 */
public struct StatusUpdateFilters {
    /// Messages that contain Message.groupChatCreated, Message.supergroupChatCreated or Message.channelChatCreated
    public static var chatCreated: Filters { return Filters(filter: ChatCreatedFilter()) }
    
    /// Messages that contain Message.deleteChatPhoto
    public static var deleteChatPhoto: Filters { return Filters(filter: DeleteChatPhotoFilter()) }
    
    /// Messages that contain Message.leftChatMember
    public static var leftChatMember: Filters { return Filters(filter: LeftChatMemberFilter()) }
    
    /// Messages that contain Message.migrateFromChatId
    public static var migrate: Filters { return Filters(filter: MigrateFilter()) }
    
    /// Messages that contain Message.newChatMembers
    public static var newChatMembers: Filters { return Filters(filter: NewChatMembersFilter()) }
    
    /// Messages that contain Message.newChatPhoto
    public static var newChatPhoto: Filters { return Filters(filter: NewChatPhotoFilter()) }
    
    /// Messages that contain Message.newChatTitle
    public static var newChatTitle: Filters { return Filters(filter: NewChatTitleFilter()) }
    
    /// Messages that contain Message.pinnedMessage
    public static var pinnedMessage: Filters { return Filters(filter: PinnedMessageFilter()) }
}

/// Messages that contain Message.groupChatCreated, Message.supergroupChatCreated or Message.channelChatCreated
public struct ChatCreatedFilter: Filter {
    
    public var name: String = "chat_created"
    
    public func filter(message: Message) -> Bool {
        return message.channelChatCreated != nil ||
            message.supergroupChatCreated != nil ||
            message.channelChatCreated != nil
    }
}

/// Messages that contain Message.deleteChatPhoto
public struct DeleteChatPhotoFilter: Filter {
    
    public var name: String = "delete_chat_photo"
    
    public func filter(message: Message) -> Bool {
        return message.deleteChatPhoto != nil
    }
}

/// Messages that contain Message.leftChatMember
public struct LeftChatMemberFilter: Filter {
    
    public var name: String = "left_chat_member"
    
    public func filter(message: Message) -> Bool {
        return message.leftChatMember != nil
    }
}

/// Messages that contain Message.migrateFromChatId
public struct MigrateFilter: Filter {
    
    public var name: String = "migrate"
    
    public func filter(message: Message) -> Bool {
        return message.migrateFromChatId != nil ||
            message.migrateToChatId != nil
    }
}

/// Messages that contain Message.newChatMembers
public struct NewChatMembersFilter: Filter {
    
    public var name: String = "new_chat_members"
    
    public func filter(message: Message) -> Bool {
        return message.newChatMembers != nil
    }
}

/// Messages that contain Message.newChatPhoto
public struct NewChatPhotoFilter: Filter {
    
    public var name: String = "new_chat_photo"
    
    public func filter(message: Message) -> Bool {
        guard let photos = message.newChatPhoto else { return false }
        return !photos.isEmpty
    }
}

/// Messages that contain Message.newChatTitle
public struct NewChatTitleFilter: Filter {
    
    public var name: String = "new_chat_title"
    
    public func filter(message: Message) -> Bool {
        return message.newChatTitle != nil
    }
}

/// Messages that contain Message.pinnedMessage
public struct PinnedMessageFilter: Filter {
    
    public var name: String = "pinned_message"
    
    public func filter(message: Message) -> Bool {
        return message.pinnedMessage != nil
    }
}
