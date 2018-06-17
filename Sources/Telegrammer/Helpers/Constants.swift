//
//  Constants.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 11/06/2018.
//

import Foundation

public struct Const {
    static let MessageMaxLength: Int = 4096
    static let CaptionMaxLength: Int = 200
    static let WebhooksSupportedPorts: [Int] = [443, 80, 88, 8443]
    static let DownloadFileMaxSize: Int = 20 //TODO: rewrite in bytes
    static let UploadFileMaxSize: Int = 50 //TODO: rewrite in bytes
    ///Telegram may allow short bursts that go over this limit, but eventually you’ll begin receiving 429 errors.
    static let MessagesMaxPerSecondPerChat: Int = 1
    static let MessagesMaxPerSecond: Int = 30
    static let MessagesMaxPerMinutePerGroup: Int = 20
    static let InlineQueryMaxResults: Int = 50
    ///Beyond this cap telegram will simply ignore further formatting styles
    static let MessagesMaxEntities: Int = 100
}
