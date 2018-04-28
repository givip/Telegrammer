//
//  Network.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 09.04.2018.
//

import NIO
import HTTP

/// Convenience shorthand for `EventLoopFuture`.
public typealias Future = EventLoopFuture

/// Convenience shorthand for `EventLoopPromise`.
public typealias Promise = EventLoopPromise

public protocol Connection {
	var bot: Bot { get }
	var dispatcher: Dispatcher { get }
	var worker: Worker { get }
	var running: Bool { get set }
}
