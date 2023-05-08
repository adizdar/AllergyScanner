//
//  MyIngridientsViewModel.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 08.05.23.
//

import SwiftUI
import Combine

class MyIngridientsViewModel: ObservableObject {
	@Published var ingridentsToScanText: String = ""
	@Published var matchedIngredients: [Ingredient] = []
	@Published var ingredients: [Ingredient] = []

	private var store = IngredientStore()
	private var cancellables = Set<AnyCancellable>()

	init() {
		// Workaround for a larger list set, regarding performance isseus
		DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
			// Subscribe to the publisher to receive updates from the store
			self.store.publisher()
				.sink { [weak self] ingredients in
					self?.ingredients = ingredients
				}
			.store(in: &self.cancellables)
		}
	}

	func filteredIngredients(for searchText: String) -> [Ingredient] {
		if searchText.isEmpty {
			return self.ingredients
		} else {
			return self.ingredients.filter {
				$0.name.localizedCaseInsensitiveContains(searchText)
			}
		}
	}

	func clearAllSavedIngridients() {
		self.store.clear()
	}

	func deleteIngridient(at offsets: IndexSet) {
		self.store.remove(at: offsets)
	}

	func refresh() {
		self.ingredients = self.store.load()
	}
}
