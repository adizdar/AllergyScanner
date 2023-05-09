//
//  MyIngridientsView.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 08.05.23.
//

import SwiftUI

struct MyIngridientsView: View {
	@ObservedObject var viewModel: MyIngridientsViewModel
	@State private var searchText: String = ""

	var body: some View {
		VStack {
			NavigationView {
				let result = viewModel.filteredIngredients(for: searchText)
				List(selection: $viewModel.selection) {
					if result.isEmpty {
						Text("No results found")
					} else {
						ForEach(result) { ingredient in
							Text(ingredient.name)
								.tag(ingredient.id)
								.contextMenu {
									Button(action: {
										UIPasteboard.general.string = ingredient.name
									}) {
										Label("Copy", systemImage: "doc.on.doc")
									}
								}
						}
						.onDelete(perform: viewModel.deleteIngridient)
					}
				}
				.listStyle(InsetGroupedListStyle())
				.searchable(text: $searchText, prompt: "Search")
				.navigationTitle("Saved ingredients")
				.toolbar {
					ToolbarItemGroup(placement: .navigationBarLeading) {
						ClearAllButton(
							operation: viewModel.clearAllSavedIngridients
						)
					}
					ToolbarItemGroup(placement: .navigationBarTrailing) {
						HStack {
							Text("\(result.count) items")
								.font(.callout)
								.foregroundColor(.secondary)

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
			}
		}
		.padding()
		.onAppear { viewModel.refresh() }
	}
}

struct MyIngridientsView_Previews: PreviewProvider {
    static var previews: some View {
		MyIngridientsView(viewModel: MyIngridientsViewModel())
    }
}
