//
//  Enviroment+Helper.swift
//  Async
//
//  Created by Givi Pataridze on 10.04.2018.
//

import Foundation

public struct Enviroment {
    public static func get(_ key: String) -> String? {
        return ProcessInfo.processInfo.environment[key]
    }
}
