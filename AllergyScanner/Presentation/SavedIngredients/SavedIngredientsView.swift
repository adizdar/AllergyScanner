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
			HStack {
				ClearAllButton(operation: viewModel.clearSaveEditor)
					.padding(.horizontal)

				Button {
					viewModel.showingImporter = true
				} label: {
					Label("Import", systemImage: "square.and.arrow.down")
				}
				.buttonStyle(.borderless)
				.fileImporter(
					isPresented: $viewModel.showingImporter,
					allowedContentTypes: [.plainText],
					allowsMultipleSelection: false
				) { result in
					do {
						try viewModel.importIngridients(result: result)
					} catch {
						// TODO error handling
						print(error.localizedDescription)
					}
				}
			}

			TextEditor(text: $viewModel.ingridentsToSaveText)
				.focused($hasFocused)
				.sync($viewModel.hasFocused, with: _hasFocused)
				.font(.system(size: 16, weight: .regular))
				.foregroundColor(.primary)
				.padding()
				.background(Color(.secondarySystemBackground))
				.cornerRadius(10)

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
					Text("Saved!")
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
