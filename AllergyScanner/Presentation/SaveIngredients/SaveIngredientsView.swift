//
//  SavedIngredientsView.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 07.05.23.
//

import SwiftUI

struct SaveIngredientsView: View {
	@ObservedObject var viewModel: SaveIngredientsViewModel
	@FocusState private var hasFocused: Bool

	var body: some View {
		VStack {
			IngridientTextEditor(
				text: $viewModel.ingridentsToSaveText,
				bindableHasFocues: $viewModel.hasFocused,
				showingFileImporter: $viewModel.showingImporter,
				importIngridientUseCase: viewModel.importIngridientUseCase,
				clearOperation: viewModel.clearSaveEditor,
				getImportedIngridientsOperation: viewModel.importIngridients
			)

			TextScanButtonGroupView(
				isScanDisabled: viewModel.isSaving,
				textWithSystmeImage: (text: "save", imageName: "doc.text"),
				scanTextOperation: viewModel.saveTextAsIngridients,
				imageScanCompletedOperation: viewModel.convertScannerResultToIngridients
			)

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
		.hideKeyboard()
	}
}

struct SavedIngredientsView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			SaveIngredientsView(viewModel: SaveIngredientsViewModel())
				.previewDevice("iPhone 12 Pro Max")
				.preferredColorScheme(.light)

			SaveIngredientsView(viewModel: SaveIngredientsViewModel())
				.previewDevice("iPhone SE (2nd generation)")
				.preferredColorScheme(.dark)
		}
	}
}
