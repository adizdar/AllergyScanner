//
//  ImportIngridientUseCase.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 10.05.23.
//

import Foundation

class ImportIngridientUseCase: ObservableObject {
	func importIngridients(result: Result<[URL], Error>) throws -> String? {
		guard let selectedFile = try result.get().first else {
			return nil
		}

		guard selectedFile.startAccessingSecurityScopedResource() else {
			fatalError("TODO no rights")
		}

		let file = try TextFile(
			fileWrapper: FileWrapper(url: selectedFile)
		)

		selectedFile.stopAccessingSecurityScopedResource()

		return file.text
	}
}
