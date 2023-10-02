//
//  View+Extension.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 07.05.23.
//

import SwiftUI

extension View {
	func sync<T: Equatable>(
		_ binding: Binding<T>,
		with focusState: FocusState<T>
	) -> some View {
		self.onChange(of: binding.wrappedValue) { oldState, newState in focusState.wrappedValue = newState }
			.onChange(of: focusState.wrappedValue) { oldState, newState in binding.wrappedValue = newState }
	}

	func hideKeyboard() -> some View {
		self.onTapGesture {
			UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
		}
	}
}
