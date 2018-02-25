//
//  InputFile.swift
//  App
//
//  Created by Givi Pataridze on 28.02.2018.
//

import Foundation

/// Represents the contents of a file to be uploaded. Must be posted using multipart/form-data in the usual way that files are uploaded via the browser..
/// - SeeAlso: <https://core.telegram.org/bots/api#inputfile>

public struct InputFile: Uploadable {
	var filename: String?
	var data: Data
	var mimeType: String?
	
	public init(filename: String, data: Data, mimeType: String? = nil) {
		self.filename = filename
		self.data = data
		self.mimeType = mimeType
	}
}
