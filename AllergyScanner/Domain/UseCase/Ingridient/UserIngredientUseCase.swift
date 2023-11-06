//
//  IngredientUseCase.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 25.09.23.
//

import Combine
import Foundation
import Factory

class UserIngredientUseCase: IngredientUseCase {
	@Injected(\.ingridientRepository) private var repository

	func getFilteredIngredients(
		_ ingridients: [Ingredient],
		for searchText: String
	) -> [Ingredient] {
		if searchText.isEmpty {
			return ingridients.sorted(by: { $0.name < $1.name })
		}

		return ingridients.filter {
			$0.name.localizedCaseInsensitiveContains(searchText)
		}
	}

	func getIngridientsPublisher() -> AnyPublisher<[Ingredient], Never> {
		return self.repository.getAllPublisher()
	}

	func clearAllSavedIngredients() {
		self.repository.clearAll()
	}

	func deleteIngredient(at index: Int) {
		guard index >= 0 else { return }

		self.repository.remove(at: index)
	}

	func refreshIngredients() -> [Ingredient] {
		return self.repository.load()
	}

	func createIngredientsDocument() -> TextFile {
		return TextFile(text: self.repository.makeTextRepresentation())
	}
}
