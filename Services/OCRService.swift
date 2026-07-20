//
//  OCRService.swift
//  Hidden Fee App
//
//  Created by Everyone Can Code Chicago on 7/20/26.
//

import SwiftUI
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
    
    func recognizeText(in images: [UIImage]) async throws -> String {
        var pages: [String] = []
        for image in images {
            let text = try await recognizeText(in: image)
            pages.append(text)
        }
        return pages.joined(separator: "\n\n")
    }
    
    func recognizeText(in image: UIImage) async throws -> String {
        guard let cgImage = image.cgImage else { throw OCRError.invalidImage }
        
        return try await withCheckedThrowingContinuation { continuation in
            let request = VNRecognizeTextRequest { request, error in
                if let error = error {
                    continuation.resume(throwing: OCRError.recognitionFailed(error))
                    return
                }
                let observations = request.results as? [VNRecognizedTextObservation] ?? []
                let lines = observations.compactMap { $0.topCandidates(1).first?.string }
                continuation.resume(returning: lines.joined(separator: "\n"))
            }
            
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try handler.perform([request])
                } catch {
                    continuation.resume(throwing: OCRError.recognitionFailed(error))
                }
            }
        }
    }
}
