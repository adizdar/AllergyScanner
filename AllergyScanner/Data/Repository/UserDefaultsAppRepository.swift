//
//  UserDefaultsAppRepository.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 02.11.23.
//

import Foundation

class UserDefaultsAppRepository: AppRepository {
	private let key = "hasShownPopup"
	private let userDefaults = UserDefaults.standard

	func getHasShownPastePermissionPopup() -> Bool {
		return userDefaults.bool(forKey: self.key)
	}

	func setShownPastePermissionPopup(_ value: Bool) {
		userDefaults.set(value, forKey: self.key)
	}
}
