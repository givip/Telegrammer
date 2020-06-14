//
//  VideoNoteFilter.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

/// Messages that contain `VideoNote`
public struct VideoNoteFilter: Filter {

    public var name: String = "video_note"

    public func filter(message: Message) -> Bool {
        return message.videoNote != nil
    }
}

public extension Filters {
    static var videoNote = Filters(filter: VideoNoteFilter())
}
