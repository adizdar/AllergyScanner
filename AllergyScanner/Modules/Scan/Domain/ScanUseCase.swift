//
//  ScanUseCase.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 10.05.23.
//

import Factory
import Foundation

class ScanUseCase {
	@Injected(\.scanRepository) private var repository

	func scanTextForIngredients(_ text: String) -> [Ingredient] {
		let ingredientsToScan = text.makeTextToUniqueIngridientsTextArray()
		let matchingIngredients = ingredientsToScan.flatMap {
			repository.matchIngredients(query: $0)
		}

		return matchingIngredients
	}
}
