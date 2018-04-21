//
//  FileInfo.swift
//  App
//
//  Created by Givi Pataridze on 01.03.2018.
//

import Foundation

public enum FileInfo: Uploadable {
	
	case fileId(String)
	case url(String)
	case file(InputFile)
	
	var data: Data {
		switch self {
		case .fileId(let id):
			return id.convertToData()
		case .url(let url):
			return url.convertToData()
		case .file(let file):
			return file.data
		}
	}
	
	var filename: String? {
		switch self {
		case .file(let file):
			return file.filename
		default:
			return nil
		}
	}
	
	var mimeType: String? {
		switch self {
		case .file(let file):
			return file.mimeType
		default:
			return nil
		}
	}
	
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

