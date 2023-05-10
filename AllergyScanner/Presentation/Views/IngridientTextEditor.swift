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
	@Environment(\.colorScheme) var colorScheme

	var body: some View {
		let defaultFillColor = self.colorScheme == .dark ? Color.black : Color.white
		let defaultShwadowColor = self.colorScheme == .dark ? Color.white : Color.black

		VStack {
			HStack {
				ClearAllButton(operation: clearOperation)

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
				.cornerRadius(10)
				.foregroundColor(Color.primary)
				.padding(4)
				.background(
					RoundedRectangle(cornerRadius: 10)
						.fill(defaultFillColor)
						.shadow(
							color: hasFocused ? .accentColor.opacity(0.5) : defaultShwadowColor.opacity(0.2),
							radius: 5,
							x: 0,
							y: 2
						)
				)
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
