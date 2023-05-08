//
//  SavedIngredientsViewModel.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 07.05.23.
//

import Foundation
import SwiftUI
import Combine

class SavedIngredientsViewModel: ObservableObject {
	@Published var ingridentsToSaveText: String = ""
	@Published var loadedText: String = ""
	@Published var showSaveConfirmation: Bool = false
	@Published var showProgressBar: Bool = false
	@Published var ingredients: [Ingredient] = []
	@Published var matchedIngredients: [Ingredient] = []
	@Published var hasFocused: Bool = false

	var isSaving: Bool {
		return showProgressBar || showSaveConfirmation
	}

	private var store = IngredientStore()
	private var cancellables = Set<AnyCancellable>()

	func saveTextAsIngridients() {
		self.showProgressBar = true
		saveToStore() { self.ingridentsToSaveText.makeTextToIngridients() }
		self.ingridentsToSaveText = ""
		self.hasFocused = false
	}

	private func saveToStore(using operation: () -> [Ingredient]) {
		self.showProgressBar = true

		let newIngredients = operation()

		Just(newIngredients)
			.delay(for: .seconds(1), scheduler: DispatchQueue.main)
			.sink { [weak self] data in
				guard let self = self else {
					// TODO add error handling
					return
				}

				self.store.saveUnique(ingredients: data)

				withAnimation {
					self.showProgressBar = false
					self.showSaveConfirmation = true
				}

				DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
					withAnimation {
						self.showSaveConfirmation = false
					}
				}
			}
			.store(in: &cancellables)
	}
}

extension String {
	fileprivate func makeTextToIngridients() -> [Ingredient] {
		return self.makeTextToUniqueIngridientsTextArray().map {
			Ingredient(name: $0)
		}
	}
}
