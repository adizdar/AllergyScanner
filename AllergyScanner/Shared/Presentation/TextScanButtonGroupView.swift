//
//  ScanButtonGroupView.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 11.05.23.
//

import SwiftUI

struct TextScanButtonGroupView: View {
	typealias TextWithSystmeImage = (text: String, imageName: String)

	var isScanDisabled: Bool
	var textWithSystmeImage: TextWithSystmeImage = ("scan", "text.magnifyingglass")
	let scanTextOperation: () -> ()
	let imageScanCompletedOperation: (String) -> ()
	@State private var isShowingScannerSheet = false

    var body: some View {
		HStack {
			Button {
				self.scanTextOperation()
			} label: {
				Label(
					self.textWithSystmeImage.text,
					systemImage: self.textWithSystmeImage.imageName
				)
					.frame(maxWidth: .infinity)
			}
			.disabled(self.isScanDisabled)
			.buttonStyle(.borderedProminent)

			Button {
				self.isShowingScannerSheet = true
			} label: {
				Label("via Camera", systemImage: "doc.text.viewfinder")
					.frame(maxWidth: .infinity)
			}
			.disabled(self.isScanDisabled)
			.buttonStyle(.borderedProminent)
			.sheet(isPresented: $isShowingScannerSheet) {
				CameraController(
					completion: { textPerPage in
						self.imageScanCompletedOperation(
							textPerPage.joined(separator: "\n")
						)
						self.isShowingScannerSheet = false
					}
				)
			}
		}
    }
}

struct ScanButtonGroupView_Previews: PreviewProvider {
    static var previews: some View {
		TextScanButtonGroupView(
			isScanDisabled: false,
			scanTextOperation: {},
			imageScanCompletedOperation: { _ in }
		)
    }
}
