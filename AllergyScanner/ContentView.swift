//
//  ContentView.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 06.05.23.
//

import SwiftUI

struct ContentView: View {
	@EnvironmentObject private var scanDataSource: ScanDataSource

	@StateObject private var savedViewModel = SaveIngredientsViewModel()
	@StateObject private var myIngridientsViewModel = MyIngridientsViewModel()

	var body: some View {
		@StateObject var scanViewModel = ScanViewModel(
			scanUseCase: ScanUseCase(repository: scanDataSource)
		)

		TabView {
			ScanView(viewModel: scanViewModel)
				.tabItem {
					Label("Scan", systemImage: "qrcode.viewfinder")
				}
				.tag(0)

			SaveIngredientsView(viewModel: savedViewModel)
				.tabItem {
					Label("Save", systemImage: "tray.and.arrow.down")
				}
				.tag(1)

			MyIngridientsView(viewModel: myIngridientsViewModel)
				.tabItem {
					Label("My Ingridients", systemImage: "tray.full")
				}
				.tag(2)
		}
		.accentColor(Color(UIColor.systemTeal))
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
