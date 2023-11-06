//
//  MyIngridientsView.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 08.05.23.
//

import SwiftUI

struct MyIngridientsView: View {
	@ObservedObject var viewModel: MyIngridientsViewModel

	var body: some View {
		VStack {
			NavigationView {
				List(selection: $viewModel.selection) {
					if viewModel.ingridientsToDisplay.isEmpty {
						NoResultsView()
					} else {
						ForEach(viewModel.ingridientsToDisplay) { ingredient in
							ModernListRow(ingredient: ingredient)
						}
						.onDelete(perform: viewModel.deleteIngridient)
					}
				}
				.listStyle(.plain)
				.navigationTitle("\(viewModel.ingridientsToDisplay.count) ingredients")
				.searchable(text: $viewModel.searchText, prompt: "Search")
				.toolbar {
					ToolbarItemGroup(placement: .navigationBarLeading) {
						ClearAllButton(
							operation: viewModel.clearAllSavedIngridients
						)
						.tint(.red)
					}
					ToolbarItemGroup(placement: .navigationBarTrailing) {
						HStack {
							Button {
								viewModel.createIngridientsDocument()
							} label: {
								Label("Export", systemImage: "square.and.arrow.up")
							}
							.buttonStyle(.borderless)
							.help("Export ingredients to a text file")
							.fileExporter(
								isPresented: $viewModel.showingExporter,
								document: viewModel.document,
								contentType: .plainText,
								defaultFilename: "ingridiends_exported_allergy_scanner_app"
							) { result in
								switch result {
								case .success(let url):
									print("Saved to \(url)")
								case .failure(let error):
										// TODO error handling
									print(error.localizedDescription)
								}
							}
						}
					}
				}
				.navigationBarTitleDisplayMode(.inline)
			}
		}
		.padding()
		.onAppear { viewModel.refresh() }
	}
}

private struct NoResultsView: View {
	var body: some View {
		Text("No results found")
	}
}

struct MyIngridientsView_Previews: PreviewProvider {
    static var previews: some View {
		MyIngridientsView(viewModel: MyIngridientsViewModel())
    }
}
