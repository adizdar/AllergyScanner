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

	var isScanDisabled: Bool {
		return self.isScanning
	}

	private var store = IngredientStore()
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
					self.store.matchIngredients(query: $0)
				}

				self.matchedIngredients = matchingIngredients

				withAnimation {
					self.isScanning = false
				}
			}
			.store(in: &cancellables)
	}
}
