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

	var body: some View {
		VStack {
			TextEditor(text: $viewModel.ingridentsToScanText)
				.focused($hasFocused)
				.sync($viewModel.hasFocused, with: _hasFocused)
				.font(.system(size: 16, weight: .regular))
				.foregroundColor(.primary)
				.padding()
				.background(Color(.secondarySystemBackground))
				.cornerRadius(10)

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
				Text("Open Camera")
					.frame(maxWidth: .infinity)
			}
			.disabled(viewModel.isScanDisabled)
			.buttonStyle(.borderedProminent)
			.sheet(isPresented: $viewModel.isShowingScannerSheet) {
				ScannerView(
					completion: viewModel.convertScannerResultToIngridients
				)
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
				List {
					ForEach(viewModel.matchedIngredients) { ingredient in
						Text(ingredient.name)
					}
				}
			}
		}
		.padding()
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
