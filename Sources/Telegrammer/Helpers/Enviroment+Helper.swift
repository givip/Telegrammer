//
//  Enviroment+Helper.swift
//  Async
//
//  Created by Givi Pataridze on 10.04.2018.
//

import Foundation
import Logging

public struct Enviroment {
    /**
     Use this method to find Enviroment variable of your system. If such variable not found, returns `nil`

     - Parameters:
        - key: Enviroment variable name
     - Returns: Optional String
     */
    public static func get(_ key: String) -> String? {
        log.info("Searching enviroment variable \(key)")
        return ProcessInfo.processInfo.environment[key]
    }
}
