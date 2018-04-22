//
//  Bundle+Helper.swift
//  App
//
//  Created by Givi Pataridze on 03.03.2018.
//

import Foundation

public extension Bundle {
	static func file(with name: String) throws -> Data? {
		let filename = name.components(separatedBy: ".")
		guard let url = Bundle.main.url(forResource: filename.first, withExtension: filename.last) else { return nil }
		return try Data(contentsOf: url)
	}
}
