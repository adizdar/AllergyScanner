//
//  TextEditorWithPlaceholder.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 09.05.23.
//

import Factory
import SwiftUI

struct IngridientTextEditor: View {
	@Binding var text: String
	@Binding var bindableHasFocues: Bool
	@Binding var showingFileImporter: Bool
	@State var clipboardContent: String? = nil
	@Environment(\.colorScheme) var colorScheme

	let importIngridientUseCase: ImportIngridientUseCase
	let clearOperation: () -> ()
	let getImportedIngridientsOperation: (String?) -> ()

	@FocusState private var hasFocused: Bool
	@Injected(\.pasteTextUseCase) private var pasteTextUseCase
	@Injected(\.appSettingsUseCase) private var appSettingsUseCase

	var body: some View {
		let defaultFillColor = self.colorScheme == .dark ? Color.black : Color.white
		let defaultShwadowColor = self.colorScheme == .dark ? Color.white : Color.black

		VStack {
			HStack {
				ClearAllButton(operation: clearOperation)

				Button {
					showingFileImporter = true
				} label: {
					Label(
						"Import",
						systemImage: "square.and.arrow.down"
					)
				}
				.buttonStyle(.borderless)
				.fileImporter(
					isPresented: $showingFileImporter,
					allowedContentTypes: [.plainText],
					allowsMultipleSelection: false
				) { result in
					do {
						getImportedIngridientsOperation(
							try importIngridientUseCase.importIngridients(
								result: result
							)
						)
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
				.overlay(
					ZStack {
						Button {
							self.text = self.pasteTextUseCase.clipboardContent ?? ""
							self.pasteTextUseCase.clear()
						} label : {
							Label("Paste", systemImage: "doc.on.clipboard")
						}
						.opacity(self.pasteTextUseCase.clipboardContent != nil ? 1 : 0)
						.labelStyle(.iconOnly)
						.buttonStyle(.borderedProminent)
						.buttonBorderShape(.roundedRectangle(radius: 10))
						.tint(Color.orange)
					}
						.frame(maxWidth: .infinity, 
							   maxHeight: .infinity,
							   alignment: .bottomTrailing
						)
						.padding(10)
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
			importIngridientUseCase: ImportIngridientUseCase(),
			clearOperation: {},
			getImportedIngridientsOperation: { result in }
		)
	}
}
