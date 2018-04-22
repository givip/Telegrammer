//
//  Enviroment+Helper.swift
//  Async
//
//  Created by Givi Pataridze on 10.04.2018.
//

import Foundation
import LoggerAPI

public struct Enviroment {
    public static func get(_ key: String) -> String? {
        Log.info("Searching Telegram bot TOKEN in enviroment variable \(key)")
        return ProcessInfo.processInfo.environment[key]
    }
}
