//
//  ContentView.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 06.05.23.
//

import SwiftUI
import Factory

struct ContentView: View {
	@StateObject private var scanViewModel = ScanViewModel()
	@StateObject private var savedViewModel = SaveIngredientsViewModel()
	@StateObject private var myIngridientsViewModel = MyIngridientsViewModel()

	@State private var showPastePermissionAlert = false
	@Injected(\.appSettingsUseCase) private var appSettingsUseCase

	var body: some View {
		TabView {
			ScanView(viewModel: scanViewModel)
				.tabItem {
					Label("Scan", systemImage: "doc.viewfinder.fill")
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
		.alert(isPresented: $showPastePermissionAlert) {
			Alert(
				title: Text("Paste text permission"),
				message: Text("This app would like permission to access your clipboard so you can paste text into it. To allow please choose Paste from Other Apps to Allow."),
				primaryButton: .default(Text("Cancel")),
				secondaryButton: .default(Text("Go to Settings")) {
					AppSettingsUseCase().openSettings()
				}
			)
		}
		.onAppear {
			if !self.appSettingsUseCase.hasShownPastePermissionPopup() {
				self.showPastePermissionAlert = true
				self.appSettingsUseCase.setShwonPastePermissionPopup(true)
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
