//
//  ContentView.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 06.05.23.
//

import SwiftUI

struct ContentView: View {
	@StateObject private var savedViewModel = SavedIngredientsViewModel()
	@StateObject private var scanViewModel = ScanViewModel()
	@StateObject private var myIngridientsViewModel = MyIngridientsViewModel()

	var body: some View {
		TabView {
			ScanView(viewModel: scanViewModel)
				.tabItem {
					Label("Scan", systemImage: "1.circle")
				}

			SavedIngredientsView(viewModel: savedViewModel)
				.tabItem {
					Label("Save", systemImage: "2.circle")
				}

			MyIngridientsView(viewModel: myIngridientsViewModel)
				.tabItem {
					Label("My Ingridients", systemImage: "3.circle")
				}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			ContentView()
				.previewDevice("iPhone 12 Pro Max")
				.preferredColorScheme(.light)

			ContentView()
				.previewDevice("iPhone SE (2nd generation)")
				.preferredColorScheme(.dark)
		}
	}
}
