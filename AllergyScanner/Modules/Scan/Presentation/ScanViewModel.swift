//
//  ScanViewModel.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 07.05.23.
//

import Foundation
import SwiftUI
import Combine

class ScanViewModel: ObservableObject {
	@Published var ingridentsToScanText: String = ""
	@Published var matchedIngredients: [Ingredient] = []
	@Published var isShowingScannerSheet = false
	@Published var hasFocused: Bool = false
	@Published var isScanning = false
	@Published var showingImporter = false
	@Published var selection: Set<Ingredient.ID> = []

	var isScanDisabled: Bool {
		return self.isScanning
	}

	private let scanUseCase: ScanUseCase
	private var cancellables = Set<AnyCancellable>()

	init(scanUseCase: ScanUseCase) {
		self.scanUseCase = scanUseCase
	}

	func convertScannerResultToIngridients(textPerPage: [String]) {
		self.ingridentsToScanText = textPerPage.joined(separator: "\n")
		self.isShowingScannerSheet = false
	}

	func showScannerView() {
		self.isShowingScannerSheet = true
	}

	func scanTextForIngridients() {
		self.hasFocused = false
		self.isScanning = true

		let ingredientsToScan = self.ingridentsToScanText
			.makeTextToUniqueIngridientsTextArray()

		Just(ingredientsToScan)
			.delay(for: .seconds(1), scheduler: DispatchQueue.main)
			.sink { [weak self] data in
				guard let self = self else {
					// TODO add error handling
					return
				}

				let matchingIngredients = ingredientsToScan.flatMap {
					self.scanUseCase.scanTextForIngredients($0)
				}

				self.matchedIngredients = matchingIngredients

				withAnimation {
					self.isScanning = false
				}
			}
			.store(in: &cancellables)
	}

	func importIngridients(result: Result<[URL], Error>) throws {
		guard let selectedFile = try result.get().first else {
			// TODO add error handling or throw error
			return
		}

		guard selectedFile.startAccessingSecurityScopedResource() else {
			fatalError("TODO no rights")
		}

		let file = try TextFile(
			fileWrapper: FileWrapper(url: selectedFile)
		)

		self.ingridentsToScanText = file.text

		selectedFile.stopAccessingSecurityScopedResource()
	}

	func clearScan() {
		self.hasFocused = false
		self.ingridentsToScanText = ""
		self.matchedIngredients = []
	}
}
