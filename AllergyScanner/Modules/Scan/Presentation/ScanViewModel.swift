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

	var scanUseCase: ScanUseCase?
	private var cancellables = Set<AnyCancellable>()

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

		Just(self.ingridentsToScanText)
			.delay(for: .seconds(1), scheduler: DispatchQueue.main)
			.sink { [weak self] data in
				guard let self = self else {
				// TODO add error handling
					return
				}

				guard let scanUseCase = self.scanUseCase else {
					fatalError("Scan use case has not been initialised.")
				}

				self.matchedIngredients = scanUseCase.scanTextForIngredients(data)

				withAnimation {
					self.isScanning = false
				}
			}
			.store(in: &cancellables)
	}

	func importIngridients(_ result: String?) {
		guard let text = result else {
			return
		}

		self.ingridentsToScanText = text
	}

	func clearScan() {
		self.hasFocused = false
		self.ingridentsToScanText = ""
		self.matchedIngredients = []
	}
}
