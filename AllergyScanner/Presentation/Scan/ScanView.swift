//
//  ScanView.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 07.05.23.
//

import SwiftUI
import Vision

struct ScanView: View {
	@ObservedObject var viewModel: ScanViewModel
	@FocusState private var hasFocused: Bool

	var body: some View {
		VStack {
			IngridientTextEditor(
				text: $viewModel.ingridentsToScanText,
				bindableHasFocues: $viewModel.hasFocused,
				showingFileImporter: $viewModel.showingImporter,
				importIngridientUseCase: viewModel.importIngridientUseCase,
				clearOperation: viewModel.clearScan,
				getImportedIngridientsOperation: viewModel.importIngridients
			)

			TextScanButtonGroupView(
				isScanDisabled: viewModel.isScanDisabled,
				scanTextOperation: viewModel.scanTextForIngridients,
				imageScanCompletedOperation: viewModel.convertScannerResultToIngridients
			)

			if viewModel.isScanning {
				ProgressView()
					.progressViewStyle(CircularProgressViewStyle())
					.padding()
			} else if viewModel.matchedIngredients?.isEmpty == true {
				HStack {
					Image(systemName: "exclamationmark.triangle.fill")
						.font(.title3)
						.foregroundColor(.secondary)
					Text("No matches found")
						.font(.title3)
						.foregroundColor(.secondary)
						.multilineTextAlignment(.center)
				}
				.padding()
			} else if (viewModel.matchedIngredients?.isEmpty == false) {
				List(selection: $viewModel.selection) {
					ForEach(viewModel.matchedIngredients ?? []) { ingredient in
						ModernListRow(ingredient: ingredient)
					}
				}
				.listStyle(.plain)
			}
		}
		.padding()
		.hideKeyboard()
	}
}

struct ScanView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			ScanView(viewModel: ScanViewModel())
			.previewDevice("iPhone 12 Pro Max")
			.preferredColorScheme(.light)

			ScanView(viewModel: ScanViewModel())
			.previewDevice("iPhone SE (2nd generation)")
			.preferredColorScheme(.dark)
		}
	}
}
