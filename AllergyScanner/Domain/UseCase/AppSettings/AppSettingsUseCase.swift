//
//  OpenAppSettingsUseCase.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 29.10.23.
//

import Foundation
import Factory
import UIKit

class AppSettingsUseCase {
	@Injected(\.appRepository) private var repository

	func openSettings() {
		if let url = URL(string: UIApplication.openSettingsURLString) {
			UIApplication.shared.open(url)
		}
	}

	func hasShownPastePermissionPopup() -> Bool {
		return repository.getHasShownPastePermissionPopup() 
	}

	func setShwonPastePermissionPopup(_ value: Bool) {
		repository.setShownPastePermissionPopup(value)
	}
}
