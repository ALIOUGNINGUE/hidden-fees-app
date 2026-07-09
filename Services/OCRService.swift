//
//  OCRService.swift
//  Hidden Fee App
//
//  Created by Everyone Can Code Chicago on 7/6/26.
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
    
    
    func recognizeText(in images: [UIImage]) async throws -> String {
        let pages: [String] = []
        return pages.joined(separator: "\n\n")
    }
}
