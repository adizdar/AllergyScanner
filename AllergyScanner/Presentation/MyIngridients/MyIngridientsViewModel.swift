//
//  MyIngridientsViewModel.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 08.05.23.
//

import SwiftUI
import Combine
import Factory

class MyIngridientsViewModel: ObservableObject {
	@Published var ingridentsToScanText: String = ""
	@Published var matchedIngredients: [Ingredient] = []
	@Published var selection: Set<Ingredient.ID> = []
	@Published var showingExporter = false
	@Published var document: TextFile?
	@Published var searchText: String = ""

	var ingridientsToDisplay: [Ingredient] {
		return self.ingridientUseCase
			.getFilteredIngredients(self.ingredients, for: searchText)
	}

	@Injected(\.ingridientUseCase) private var ingridientUseCase

	@Published private var ingredients: [Ingredient] = []
	private var cancellables = Set<AnyCancellable>()

	init() {
		// Workaround for a larger list set, regarding performance isseus
		DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
			// Subscribe to the publisher to receive updates from the store
			self.ingridientUseCase.getIngridientsPublisher()
				.sink { [weak self] ingredients in
					self?.ingredients = ingredients
				}
			.store(in: &self.cancellables)
		}
	}

	func clearAllSavedIngridients() {
		self.ingridientUseCase.clearAllSavedIngredients()
	}

	func deleteIngridient(at offsets: IndexSet) {
		for index in offsets {
			guard self.ingridientsToDisplay.indices.contains(index) else {
				fatalError("TODO delteing add bettter way")
			}

			let itemToDelete = self.ingridientsToDisplay[index]

			if
				let itemIndex = self.ingredients
					.firstIndex(where: { $0.id == itemToDelete.id })
			{
				self.ingridientUseCase.deleteIngredient(at: itemIndex)
			}
		}
	}

	func refresh() {
		self.ingredients = self.ingridientUseCase.refreshIngredients()
		self.document = nil
	}

	func createIngridientsDocument() {
		self.document = self.ingridientUseCase.createIngredientsDocument()
		self.showingExporter = true
	}
}
