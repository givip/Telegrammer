//
//  StatusUpdateFilters.swift
//  telegrammer-nio
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

public struct StatusUpdateFilters {
    public static var chatCreated: Filters { return Filters(filter: ChatCreatedFilter()) }
    public static var deleteChatPhoto: Filters { return Filters(filter: DeleteChatPhotoFilter()) }
    public static var leftChatMember: Filters { return Filters(filter: LeftChatMemberFilter()) }
    public static var migrate: Filters { return Filters(filter: MigrateFilter()) }
    public static var newChatMembers: Filters { return Filters(filter: NewChatMembersFilter()) }
    public static var newChatPhoto: Filters { return Filters(filter: NewChatPhotoFilter()) }
    public static var newChatTitle: Filters { return Filters(filter: NewChatTitleFilter()) }
    public static var pinnedMessage: Filters { return Filters(filter: PinnedMessageFilter()) }
}

public struct ChatCreatedFilter: Filter {
    
    public var name: String = "chat_created"
    
    public func filter(message: Message) -> Bool {
        return message.channelChatCreated != nil ||
            message.supergroupChatCreated != nil ||
            message.channelChatCreated != nil
    }
}

public struct DeleteChatPhotoFilter: Filter {
    
    public var name: String = "delete_chat_photo"
    
    public func filter(message: Message) -> Bool {
        return message.deleteChatPhoto != nil
    }
}

public struct LeftChatMemberFilter: Filter {
    
    public var name: String = "left_chat_member"
    
    public func filter(message: Message) -> Bool {
        return message.leftChatMember != nil
    }
}

public struct MigrateFilter: Filter {
    
    public var name: String = "migrate"
    
    public func filter(message: Message) -> Bool {
        return message.migrateFromChatId != nil ||
            message.migrateToChatId != nil
    }
}

public struct NewChatMembersFilter: Filter {
    
    public var name: String = "new_chat_members"
    
    public func filter(message: Message) -> Bool {
        return message.newChatMembers != nil
    }
}

public struct NewChatPhotoFilter: Filter {
    
    public var name: String = "new_chat_photo"
    
    public func filter(message: Message) -> Bool {
        guard let photos = message.newChatPhoto else { return false }
        return !photos.isEmpty
    }
}

public struct NewChatTitleFilter: Filter {
    
    public var name: String = "new_chat_title"
    
    public func filter(message: Message) -> Bool {
        return message.newChatTitle != nil
    }
}

public struct PinnedMessageFilter: Filter {
    
    public var name: String = "pinned_message"
    
    public func filter(message: Message) -> Bool {
        return message.pinnedMessage != nil
    }
}


