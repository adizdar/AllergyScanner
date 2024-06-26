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
		Factory(self) { IngredientRepositoryImpl() }
	}

	var ingridientUseCase: Factory<IngredientUseCase> {
		Factory(self) { UserIngredientUseCase() }
	}

	var importIngridientUseCase: Factory<ImportIngridientUseCase> {
		Factory(self) { ImportIngridientUseCase() }
	}

	var scanRepository: Factory<ScanDataRepository> {
		Factory(self) { IngredientRepositoryImpl() }
	}

	var scanDataUseCase: Factory<ScanUseCase> {
		Factory(self) { ScanUseCase() }
	}

	var pasteTextUseCase: Factory<PasteTextUseCase> {
		Factory(self) { PasteTextUseCase() }
	}

	var appSettingsUseCase: Factory<AppSettingsUseCase> {
		Factory(self) { AppSettingsUseCase() }
	}

	var appRepository: Factory<AppRepository> {
		Factory(self) { UserDefaultsAppRepository() }
	}
}
