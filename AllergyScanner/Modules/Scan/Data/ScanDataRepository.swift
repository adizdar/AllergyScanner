//
//  ScanDataRepository.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 10.05.23.
//

import Foundation

protocol ScanDataRepository {
	func matchIngredients(query: String) -> [Ingredient]
}
