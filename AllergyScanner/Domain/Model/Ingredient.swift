//
//  Ingridient.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 06.05.23.
//

import Foundation

struct Ingredient: Identifiable, Codable, Hashable {
	let id: UUID = UUID()
	let name: String

	init(name: String) {
		self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
	}
	
	enum CodingKeys: String, CodingKey {
		case id
		case name
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
	static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
		return lhs.id == rhs.id ||
			lhs.name.nameComperison() == rhs.name.nameComperison()
	}
}

extension String {
	fileprivate func nameComperison() -> String {
		return self.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
	}
}
