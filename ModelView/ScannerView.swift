//
//  ScannerView.swift
//  Scanner App
//
//  Created by Apple on 7/6/26.
//

import SwiftUI
import VisionKit

struct ScannerView: UIViewControllerRepresentable {

    let completionHandler: ([String]?) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(completionHandler: completionHandler)
    }

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {

        let scanner = VNDocumentCameraViewController()
        scanner.delegate = context.coordinator

        return scanner
    }

    func updateUIViewController(
        _ uiViewController: VNDocumentCameraViewController,
        context: Context
    ) {
        // Nothing to update.
    }

    // MARK: - Coordinator

    final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {

        let completionHandler: ([String]?) -> Void

        init(completionHandler: @escaping ([String]?) -> Void) {
            self.completionHandler = completionHandler
        }

        // User finished scanning
        func documentCameraViewController(
            _ controller: VNDocumentCameraViewController,
            didFinishWith scan: VNDocumentCameraScan
        ) {

            let recognizer = TextRecognizer(cameraScan: scan)

            recognizer.recognizeText { recognizedText in
                controller.dismiss(animated: true)
                self.completionHandler(recognizedText)
            }
        }

        // User tapped Cancel
        func documentCameraViewControllerDidCancel(
            _ controller: VNDocumentCameraViewController
        ) {

            controller.dismiss(animated: true)
            completionHandler(nil)
        }

        // Scanner failed
        func documentCameraViewController(
            _ controller: VNDocumentCameraViewController,
            didFailWithError error: Error
        ) {

            print("Scanner error: \(error.localizedDescription)")

            controller.dismiss(animated: true)
            completionHandler(nil)
        }
    }
}
