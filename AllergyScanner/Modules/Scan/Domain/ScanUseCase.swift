//
//  ScanUseCase.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 10.05.23.
//

import Foundation

class ScanUseCase {
	private let repository: ScanDataRepository

	init(repository: ScanDataRepository) {
		self.repository = repository
	}

	func scanTextForIngredients(_ text: String) -> [Ingredient] {
		let ingredientsToScan = text.makeTextToUniqueIngridientsTextArray()
		let matchingIngredients = ingredientsToScan.flatMap {
			repository.matchIngredients(query: $0)
		}

		return matchingIngredients
	}}
