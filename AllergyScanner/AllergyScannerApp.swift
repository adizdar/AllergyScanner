//
//  AllergyScannerApp.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 06.05.23.
//

import SwiftUI

@main
struct AllergyScannerApp: App {
	let ingredientService = IngredientService()
	let importIngridientUseCase = ImportIngridientUseCase()

    var body: some Scene {
		let scanDataSource: ScanDataSource = ScanDataSource(
			ingredientStore: ingredientService
		)

        WindowGroup {
            ContentView()
				.environmentObject(scanDataSource)
				.environmentObject(importIngridientUseCase)
        }
	}
}
