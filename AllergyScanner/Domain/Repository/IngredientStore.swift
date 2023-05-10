//
//  IngredientStore.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 06.05.23.
//

import Foundation
import Combine

private let ingredientsKey = "Ingredients"

extension UserDefaults {
	@objc fileprivate dynamic var ingredientsData: Data? {
		get {
			UserDefaults.standard.data(forKey: ingredientsKey)
		}
		set {
			UserDefaults.standard.set(newValue, forKey: ingredientsKey)
		}
	}

	fileprivate var ingridients: [Ingredient] {
		get{
			guard let data = UserDefaults.standard.data(forKey: ingredientsKey) else {
				return []
			}

			return (try? PropertyListDecoder().decode([Ingredient].self, from: data)) ?? []
		} set{
			// Set the custom objects array through the observable data property.
			ingredientsData = try? PropertyListEncoder().encode(newValue)
		}
	}
}

class IngredientStore {
	private var cancellables = Set<AnyCancellable>()
	private var ingredientUserDefaults = UserDefaults()
	private let ingredientsSubject: CurrentValueSubject<[Ingredient], Never>

	private (set) var ingredients: [Ingredient] {
		get { ingredientUserDefaults.ingridients }
		set { ingredientUserDefaults.ingridients = newValue }
	}

	init() {
		ingredientsSubject = CurrentValueSubject(ingredientUserDefaults.ingridients)
		ingredientUserDefaults.publisher(for: \.ingredientsData)
			.compactMap { $0 }
			.map { data -> [Ingredient] in
				do {
					return try PropertyListDecoder().decode(
						[Ingredient].self,
						from: data
					)
				} catch {
					return []
				}
			}
			.subscribe(ingredientsSubject)
			.store(in: &cancellables)
	}

	func matchIngredients(query: String) -> [Ingredient] {
		let matchingIngredients = self.ingredientUserDefaults.ingridients
			.filter { ingredient in
				ingredient.name.range(of: query, options: .caseInsensitive) != nil
			}

		return matchingIngredients
	}

	func saveUnique(ingredients: [Ingredient]) -> Int {
		let uniqueIngredients = ingredients.filter { ingredient in
			!self.ingredients.contains { $0 == ingredient }
		}

		self.ingredients = uniqueIngredients + self.ingredients

		return uniqueIngredients.count
	}

	func load() -> [Ingredient] {
		return ingredientUserDefaults.ingridients
	}

	func remove(at itemIndex: Int) {
		self.ingredientUserDefaults.ingridients.remove(at: itemIndex)
	}

	func clear() {
		ingredientUserDefaults.removeObject(forKey: ingredientsKey)
		self.ingredients = []
	}

	func publisher() -> AnyPublisher<[Ingredient], Never> {
		return ingredientsSubject.eraseToAnyPublisher()
	}

	func makeTextRepresentation() -> String {
		return self.ingredients
			.map { $0.name }
			.joined(separator: String.documentSeperatorForExport())
	}
}
