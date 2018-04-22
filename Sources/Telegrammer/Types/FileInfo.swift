//
//  FileInfo.swift
//  App
//
//  Created by Givi Pataridze on 01.03.2018.
//

import Foundation

public enum FileInfo: Encodable {
	
	case fileId(String)
	case url(String)
	case file(InputFile)

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		switch self {
		case .fileId(let string):
			try container.encode(string)
		case .url(let string):
			try container.encode(string)
		case .file(let file):
			try container.encode(file)
		}
	}
}

