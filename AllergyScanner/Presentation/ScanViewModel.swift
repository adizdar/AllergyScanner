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
		let ingredientsToScan = self.ingridentsToScanText
			.makeTextToUniqueIngridientsTextArray()

		let matchingIngredients = ingredientsToScan.flatMap {
			self.store.matchIngredients(query: $0)
		}

		self.matchedIngredients = matchingIngredients
		self.hasFocused = false
	}
}
