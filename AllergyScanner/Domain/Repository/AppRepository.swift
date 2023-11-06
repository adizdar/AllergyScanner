//
//  AppRepository.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 02.11.23.
//

import Foundation

protocol AppRepository {
	func getHasShownPastePermissionPopup() -> Bool
	func setShownPastePermissionPopup(_ value: Bool)
}
