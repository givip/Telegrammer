//
//  HandlerGroup.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 08.06.2018.
//

import Foundation

/**
 Class of custom handlers group.
 
 `id` represent also priority of group, lower = higher priority.
 Property `name` of group is used to determine when two group are equals. When you will try to remove
 handler from `Dispatcher`, you will need to point, from which group to delete it by mention group `name`.
 Also we offer predefined group called `zero`, which has highest priority and used in `Dispatcher` by default.
 */
public class HandlerGroup: Hashable {
	public static func == (lhs: HandlerGroup, rhs: HandlerGroup) -> Bool {
		return lhs.id == rhs.id
	}
	
	public var hashValue: Int {
		return Int(id)
	}
	
	public let id: UInt
	public let name: String
	
	public init(id: UInt, name: String) {
		self.id = id
		self.name = name
	}
	
	public static var zero = HandlerGroup(id: 0, name: "zero")
}
