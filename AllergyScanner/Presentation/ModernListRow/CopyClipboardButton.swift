//
//  CopyClipboardButton.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 15.05.23.
//

#if os(iOS)
import SwiftUI

struct CopyClipboardButton: View {
	let ingredient: Ingredient

	var body: some View {
		Button(action: {
			UIPasteboard.general.string = ingredient.name
		}) {
			Label("Copy", systemImage: "doc.on.doc")
		}
	}
}

#elseif os(macOS)
import AppKit
import SwiftUI

struct CopyClipboardButton: View {
	let ingredient: Ingredient

	var body: some View {
		Button(action: {
			NSPasteboard.general.clearContents()
			NSPasteboard.general.setString(ingredient.name, forType: .string)
		}) {
			Label("Copy", systemImage: "doc.on.doc")
		}
	}
}

#endif
