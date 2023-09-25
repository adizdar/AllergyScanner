//
//  ScannerView.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 08.05.23.
//

import SwiftUI
import VisionKit
import Vision

struct CameraController {
	var completion: ([String]) -> Void
}

// Add Coordinator to handle camera text
extension CameraController {
	class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
		var completion: ([String]) -> Void

		init(completion: @escaping ([String]) -> Void) {
			self.completion = completion
		}

		func documentCameraViewController(
			_ controller: VNDocumentCameraViewController,
			didFinishWith scan: VNDocumentCameraScan
		) {
			let extractedImages = (0..<scan.pageCount).compactMap {
				scan.imageOfPage(at: $0)
			}

			let textPerPage = extractedImages.map { extractText(from: $0) }

			completion(textPerPage)
			controller.dismiss(animated: true)
		}

		private func extractText(from image: UIImage) -> String {
			guard let cgImage = image.cgImage else { return "" }

			let requestHandler = VNImageRequestHandler(
				cgImage: cgImage,
				options: [:]
			)

			let request = VNRecognizeTextRequest()

			do {
				try requestHandler.perform([request])

				guard let observations = request.results else {
					return ""
				}

				return observations
					.compactMap { $0.topCandidates(1).first?.string }
					.joined(separator: "\n")

			} catch {
				print(error.localizedDescription)
				// TODO add error handling
				return ""
			}
		}
	}
}

// Add funcionalty top handle the camera
extension CameraController: UIViewControllerRepresentable {
	func makeCoordinator() -> Coordinator {
		Coordinator(completion: completion)
	}

	func makeUIViewController(
		context: Context
	) -> VNDocumentCameraViewController {
		let viewController = VNDocumentCameraViewController()
		viewController.delegate = context.coordinator

		return viewController
	}

	func updateUIViewController(
		_ uiViewController: VNDocumentCameraViewController, context: Context
	) {}
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
		CameraController(completion: {_ in })
    }
}
