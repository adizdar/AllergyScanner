//
//  PasteTextUseCase.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 01.10.23.
//

import Combine
import Foundation
import UIKit

class PasteTextUseCase: ObservableObject {
	@Published var clipboardContent: String?

	private var cancellable: AnyCancellable?

	init() {
		cancellable = UIPasteboard.general.hasStringsPublisher
			.map { $0 ? UIPasteboard.general.string : nil }
			.sink { [weak self] text in
				self?.clipboardContent = text
			}
	}

	deinit {
		self.cancellable?.cancel()
	}

	func clear() {
		self.clipboardContent = nil
	}
}

fileprivate extension UIPasteboard {
	var hasStringsPublisher: AnyPublisher<Bool, Never> {
		return Just(hasStrings)
			.merge(
				with: NotificationCenter.default
					.publisher(for: UIPasteboard.changedNotification, object: self)
					.map { _ in self.hasStrings }
			)
			.merge(
				with: NotificationCenter.default
					.publisher(for: UIApplication.didBecomeActiveNotification, object: nil)
					.map { _ in self.hasStrings }
			)
			.eraseToAnyPublisher()
	}
}
