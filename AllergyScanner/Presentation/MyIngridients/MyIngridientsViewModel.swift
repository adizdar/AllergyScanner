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
	@Published var selection: Set<Ingredient.ID> = []
	@Published var showingExporter = false
	@Published var document: TextFile?

	private var filterIngridients: [Ingredient] = []

	private var store = IngredientService()
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
			self.filterIngridients = self.ingredients.sorted(
				by: { $0.name < $1.name }
			)
		} else {
			self.filterIngridients = self.ingredients.filter {
				$0.name.localizedCaseInsensitiveContains(searchText)
			}
		}

		return self.filterIngridients

	}

	func clearAllSavedIngridients() {
		self.store.clear()
	}

	func deleteIngridient(at offsets: IndexSet) {
		for index in offsets {
			guard self.filterIngridients.indices.contains(index) else {
				fatalError("TODO delteing add bettter way")
			}

			let itemToDelete = self.filterIngridients[index]

			if
				let itemIndex = self.ingredients
					.firstIndex(where: { $0.id == itemToDelete.id })
			{
				self.store.remove(at: itemIndex)
			}
		}
	}

	func refresh() {
		self.ingredients = self.store.load()
		self.document = nil
	}

	func createIngridientsDocument() {
		self.document = TextFile(text: self.store.makeTextRepresentation())

		self.showingExporter = true
	}
}
