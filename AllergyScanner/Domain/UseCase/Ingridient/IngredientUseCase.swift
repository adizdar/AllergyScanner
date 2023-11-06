//
//  IngredientUseCase.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 25.09.23.
//

import Combine
import Foundation

protocol IngredientUseCase {
	func getFilteredIngredients(
		_ ingridients: [Ingredient],
		for searchText: String
	) -> [Ingredient]
	func clearAllSavedIngredients()
	func deleteIngredient(at index: Int)
	func refreshIngredients() -> [Ingredient]
	func createIngredientsDocument() -> TextFile
	func getIngridientsPublisher() -> AnyPublisher<[Ingredient], Never>
}
