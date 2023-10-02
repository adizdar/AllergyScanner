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

	var importIngridientUseCase: Factory<ImportIngridientUseCase> {
		Factory(self) { ImportIngridientUseCase() }
	}

	var scanRepository: Factory<ScanDataRepository> {
		Factory(self) { IngredientService() }
	}

	var scanDataUseCase: Factory<ScanUseCase> {
		Factory(self) { ScanUseCase() }
	}

	var pasteTextUseCase: Factory<PasteTextUseCase> {
		Factory(self) { PasteTextUseCase() }
	}
}
