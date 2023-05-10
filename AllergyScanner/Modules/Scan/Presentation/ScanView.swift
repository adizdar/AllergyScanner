//
//  ScanView.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 07.05.23.
//

import SwiftUI

struct ScanView: View {
	@ObservedObject var viewModel: ScanViewModel
	@FocusState private var hasFocused: Bool
	private let healthKitManager = HealthKitManager()

	var body: some View {
		VStack {
			IngridientTextEditor(
				text: $viewModel.ingridentsToScanText,
				bindableHasFocues: $viewModel.hasFocused,
				showingFileImporter: $viewModel.showingImporter,
				clearOperation: viewModel.clearScan,
				importFileOperation: viewModel.importIngridients
			)

			HStack {
				Button {
					viewModel.scanTextForIngridients()
				} label: {
					Text("Scan")
						.frame(maxWidth: .infinity)
				}
				.disabled(viewModel.isScanDisabled)
				.buttonStyle(.borderedProminent)

				Button {
					viewModel.showScannerView()
				} label: {
					Text("Via Camera")
						.frame(maxWidth: .infinity)
				}
				.disabled(viewModel.isScanDisabled)
				.buttonStyle(.borderedProminent)
				.sheet(isPresented: $viewModel.isShowingScannerSheet) {
					ScannerView(
						completion: viewModel.convertScannerResultToIngridients
					)
				}
			}

			if viewModel.isScanning {
				ProgressView()
					.progressViewStyle(CircularProgressViewStyle())
					.padding()
			} else if viewModel.matchedIngredients.isEmpty {
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
			} else {
				List(selection: $viewModel.selection) {
					ForEach(viewModel.matchedIngredients) { ingredient in
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
			ScanView(viewModel: ScanViewModel(
				scanUseCase: ScanUseCase(
					repository: ScanDataSource(ingredientStore: IngredientService())
				))
			)
			.previewDevice("iPhone 12 Pro Max")
			.preferredColorScheme(.light)
			
			ScanView(viewModel: ScanViewModel(
				scanUseCase: ScanUseCase(
					repository: ScanDataSource(ingredientStore: IngredientService())
				))
			)
			.previewDevice("iPhone SE (2nd generation)")
			.preferredColorScheme(.dark)
		}
	}
}
