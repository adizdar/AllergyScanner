//
//  SavedIngredientsView.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 07.05.23.
//

import SwiftUI

struct SavedIngredientsView: View {
	@ObservedObject var viewModel: SavedIngredientsViewModel
	@FocusState private var hasFocused: Bool

	var body: some View {
		VStack {
			IngridientTextEditor(
				text: $viewModel.ingridentsToSaveText,
				bindableHasFocues: $viewModel.hasFocused,
				showingFileImporter: $viewModel.showingImporter,
				clearOperation: viewModel.clearSaveEditor,
				importFileOperation: viewModel.importIngridients
			)

			Button {
				viewModel.saveTextAsIngridients()
			} label: {
				Text("Save")
					.frame(maxWidth: .infinity)
			}
			.disabled(viewModel.isSaving)
			.buttonStyle(.borderedProminent)

			if viewModel.showProgressBar {
				ProgressView()
					.progressViewStyle(CircularProgressViewStyle())
					.padding()
			}

			if viewModel.showSaveConfirmation {
				HStack {
					Spacer()
					Text("\(viewModel.numberOfSavedIngridients ?? "") Saved!")
						.foregroundColor(.green)
						.font(.headline)
					Spacer()
				}
				.padding()
				.background(Color(.systemGray6))
				.cornerRadius(10)
			}
		}
		.padding()
	}
}

struct SavedIngredientsView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			SavedIngredientsView(viewModel: SavedIngredientsViewModel())
				.previewDevice("iPhone 12 Pro Max")
				.preferredColorScheme(.light)

			SavedIngredientsView(viewModel: SavedIngredientsViewModel())
				.previewDevice("iPhone SE (2nd generation)")
				.preferredColorScheme(.dark)
		}
	}
}
