//
//  ModernListRow.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 09.05.23.
//

import SwiftUI

struct ModernListRow: View {
	let ingredient: Ingredient

	var body: some View {
		HStack(alignment: .center, spacing: 16) {
			Text(ingredient.name)
				.tag(ingredient.id)
				.font(.body)
				.foregroundColor(.primary)
				.contextMenu {
					CopyClipboardButton(ingredient: ingredient)
				}
			Spacer()
			Menu {
				CopyClipboardButton(ingredient: ingredient)
			} label: {
				Image(systemName: "ellipsis.circle")
					.foregroundColor(.primary)
			}
		}
		.padding(.vertical, 8)
	}
}

private struct ModernToolbarContent: View {
	let resultCount: Int
	let exportAction: () -> Void

	var body: some View {
		HStack(alignment: .center, spacing: 8) {
			Text("\(resultCount) items")
				.font(.caption)
				.foregroundColor(.secondary)
			Button(action: {
				exportAction()
			}) {
				Label("Export", systemImage: "square.and.arrow.up")
			}
			.buttonStyle(.borderless)
			.help("Export ingredients to a text file")
		}
	}
}

struct ModernListRow_Previews: PreviewProvider {
    static var previews: some View {
        ModernListRow(ingredient: Ingredient(name: "Test"))
    }
}
