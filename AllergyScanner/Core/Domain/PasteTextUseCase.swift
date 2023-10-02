//
//  PasteTextUseCase.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 01.10.23.
//

import Foundation
import UIKit

class PasteTextUseCase: ObservableObject {
	func getText() -> String? {
		return UIPasteboard.general.string
	}

	func clear() {
		UIPasteboard.general.string = ""
	}
}
