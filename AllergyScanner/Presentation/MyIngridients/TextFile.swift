//
//  TextFile.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 09.05.23.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct TextFile: FileDocument {
	static var readableContentTypes = [UTType.plainText]
	var text: String

	init(text: String = "") {
		self.text = text
	}

	init(configuration: ReadConfiguration) throws {
		if let data = configuration.file.regularFileContents {
			text = String(decoding: data, as: UTF8.self)
		} else {
			throw CocoaError(.fileReadCorruptFile)
		}
	}

	func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
		let data = Data(text.utf8)
		return FileWrapper(regularFileWithContents: data)
	}
}
