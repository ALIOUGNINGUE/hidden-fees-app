//
//  TextRecognizer.swift
//  Hidden Fee App
//
//  Created by Apple on 7/16/26.
//


//
//  TextRecognizer.swift
//  Scanner App
//
//  Created by Apple on 7/6/26.
//

import Foundation
import Vision
import VisionKit

final class TextRecognizer {

    private let cameraScan: VNDocumentCameraScan

    init(cameraScan: VNDocumentCameraScan) {
        self.cameraScan = cameraScan
    }

    private let queue = DispatchQueue(
        label: "TextRecognizer.queue",
        qos: .userInitiated
    )

    func recognizeText(withCompletionHandler completionHandler: @escaping ([String]) -> Void) {

        queue.async {

            let images = (0..<self.cameraScan.pageCount).compactMap {
                self.cameraScan.imageOfPage(at: $0).cgImage
            }

            var textPerPage: [String] = []

            for image in images {

                let request = VNRecognizeTextRequest()
                request.recognitionLevel = .accurate
                request.usesLanguageCorrection = true

                let handler = VNImageRequestHandler(
                    cgImage: image,
                    options: [:]
                )

                do {
                    try handler.perform([request])

                    let recognizedText = request.results?
                        .compactMap { observation in
                            observation.topCandidates(1).first?.string
                        }
                        .joined(separator: "\n") ?? ""

                    textPerPage.append(recognizedText)

                } catch {
                    print("Text recognition failed: \(error)")
                    textPerPage.append("")
                }
            }

            DispatchQueue.main.async {
                completionHandler(textPerPage)
            }
        }
    }
}
