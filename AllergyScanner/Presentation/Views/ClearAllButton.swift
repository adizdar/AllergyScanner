//
//  ClearAllButton.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 08.05.23.
//

import SwiftUI

struct ClearAllButton: View {
	let operation: () -> ()
	
    var body: some View {
		HStack {
			Button {
				operation()
			} label: {
				Text("Clear All")
					.font(.callout)
					.foregroundColor(.blue)
			}
			Spacer()
		}
    }
}

struct ClearAllButton_Previews: PreviewProvider {
    static var previews: some View {
		ClearAllButton(operation: {})
    }
}
