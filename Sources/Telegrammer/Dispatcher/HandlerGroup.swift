//
//  HandlerGroup.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 08.06.2018.
//

import Foundation

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
