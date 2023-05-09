	//
	//  TextEditorWithPlaceholder.swift
	//  AllergyScanner
	//
	//  Created by Ahmed Dizdar on 09.05.23.
	//

import SwiftUI

struct IngridientTextEditor: View {
	@Binding var text: String
	@Binding var bindableHasFocues: Bool
	@Binding var showingFileImporter: Bool
	let clearOperation: () -> ()
	let importFileOperation: (_ result: Result<[URL], Error>) throws -> ()

	@FocusState private var hasFocused: Bool

	var body: some View {
		VStack {
			HStack {
				ClearAllButton(operation: clearOperation)
					.padding(.horizontal)

				Button {
					showingFileImporter = true
				} label: {
					Label("Import", systemImage: "square.and.arrow.down")
				}
				.buttonStyle(.borderless)
				.fileImporter(
					isPresented: $showingFileImporter,
					allowedContentTypes: [.plainText],
					allowsMultipleSelection: false
				) { result in
					do {
						try importFileOperation(result)
					} catch {
						// TODO error handling
						print(error.localizedDescription)
					}
				}
			}

			TextEditor(text: $text)
				.focused($hasFocused)
				.sync($bindableHasFocues, with: _hasFocused)
				.font(.body)
				.padding(.all)
				.cornerRadius(10)
		}
	}
}

struct TextEditorWithPlaceholder_Previews: PreviewProvider {
	static var previews: some View {
		IngridientTextEditor(
			text: .constant(""),
			bindableHasFocues: .constant(false),
			showingFileImporter: .constant(false),
			clearOperation: {},
			importFileOperation: { result in }
		)
	}
}
