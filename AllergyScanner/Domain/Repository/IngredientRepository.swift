//
//  IngredientRepository.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 25.09.23.
//

import Foundation
import Combine

protocol IngredientRepository {
	func getAllPublisher() -> AnyPublisher<[Ingredient], Never>
	func remove(at index: Int)
	func clearAll()
	func load() -> [Ingredient]
	func makeTextRepresentation() -> String
}
