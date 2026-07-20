//
//  OCRService.swift
//  Hidden Fee App
//
//  Was previously a stub — `pages` was declared and never populated, so
//  the photo-library and file-upload paths silently produced empty text.
//  This mirrors TextRecognizer's approach (background queue, VNRecognizeTextRequest,
//  accurate + language correction) but operates on plain UIImages instead of
//  a VNDocumentCameraScan, since that's what PhotosPicker/file import hand back.
//

@preconcurrency import Vision
import SwiftUI

final class OCRService {

    enum OCRError: Error, LocalizedError {
        case invalidImage
        case recognitionFailed(Error)

        var errorDescription: String? {
            switch self {
            case .invalidImage:              return "The image could not be read."
            case .recognitionFailed(let e):  return "Text recognition failed: \(e.localizedDescription)"
            }
        }
    }

    private let queue = DispatchQueue(
        label: "OCRService.queue",
        qos: .userInitiated
    )

    func recognizeText(in images: [UIImage]) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            queue.async {
                do {
                    var pages: [String] = []

                    for image in images {
                        guard let cgImage = image.cgImage else {
                            throw OCRError.invalidImage
                        }

                        let request = VNRecognizeTextRequest()
                        request.recognitionLevel = .accurate
                        request.usesLanguageCorrection = true

                        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                        try handler.perform([request])

                        let recognizedText = request.results?
                            .compactMap { $0.topCandidates(1).first?.string }
                            .joined(separator: "\n") ?? ""

                        pages.append(recognizedText)
                    }

                    continuation.resume(returning: pages.joined(separator: "\n\n"))
                } catch let error as OCRError {
                    continuation.resume(throwing: error)
                } catch {
                    continuation.resume(throwing: OCRError.recognitionFailed(error))
                }
            }
        }
    }
}
