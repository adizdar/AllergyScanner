	//
	//  ScanViewModel.swift
	//  AllergyScanner
	//
	//  Created by Ahmed Dizdar on 07.05.23.
	//

import Factory
import Foundation
import SwiftUI
import Combine

class ScanViewModel: ObservableObject {
	@Published var ingridentsToScanText: String = ""
	@Published var matchedIngredients: [Ingredient]? = nil
	@Published var hasFocused: Bool = false
	@Published var isScanning = false
	@Published var showingImporter = false
	@Published var selection: Set<Ingredient.ID> = []
	@Injected(\.importIngridientUseCase) var importIngridientUseCase
	@Injected(\.scanDataUseCase) var scanUseCase

	var isScanDisabled: Bool {
		return self.isScanning
	}

	private var cancellables = Set<AnyCancellable>()

	func convertScannerResultToIngridients(scannedIngridients: String) {
		self.ingridentsToScanText = scannedIngridients
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

				self.matchedIngredients = self.scanUseCase
					.scanTextForIngredients(data)

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
		self.matchedIngredients = nil
	}
}
