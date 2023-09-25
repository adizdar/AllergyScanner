//
//  Container+Extension.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 25.09.23.
//

import Foundation
import Factory

extension Container {
	var ingridientRepository: Factory<IngredientRepository> {
		Factory(self) { IngredientService() }
	}

	var ingridientUseCase: Factory<IngredientUseCase> {
		Factory(self) { UserIngredientUseCase() }
	}
}
