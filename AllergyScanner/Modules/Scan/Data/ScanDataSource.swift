//
//  ScanDataSource.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 10.05.23.
//

import Foundation

protocol ScanDataSource: ScanDataRepository {}
extension IngredientService: ScanDataSource {}

// Other example
//class ScanDataSource: ScanDataRepository {
//	private let ingredientStore: IngredientService
//
//	init(ingredientStore: IngredientService) {
//		self.ingredientStore = ingredientStore
//	}
//
//	func matchIngredients(query: String) -> [Ingredient] {
//		return ingredientStore.matchIngredients(query: query)
//	}
//}
