//
//  AllergyScannerApp.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 06.05.23.
//

import SwiftUI

@main
struct AllergyScannerApp: App {
	private let ingredientService = IngredientService()
	private lazy var ingredientRepository: ScanDataSource = {
		return ingredientService
	}()

    var body: some Scene {
        WindowGroup {
            ContentView()
				.environmentObject(ingredientService)
        }
	}
}
