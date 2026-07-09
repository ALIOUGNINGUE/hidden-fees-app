//
//  ScannerViewModel.swift
//  Hidden Fee App
//
//  Created by Everyone Can Code Chicago on 7/6/26.
//

import SwiftUI

@Observable
@MainActor
final class ScannerViewModel {enum State: Equatable {
    case idle
    case processing
    case review
    case failed(String)
}

var state: State = .idle
var extractedText: String = ""

private let ocrService = OCRService()

func process(images: [UIImage]) async {
    guard !images.isEmpty else {
        state = .failed("No pages were scanned.")
        return
    }
    state = .processing
    do {
        let text = try await ocrService.recognizeText(in: images)
        extractedText = text
        state = .review
    } catch {
        state = .failed(error.localizedDescription)
    }
}

func loadSampleText(_ text: String) {
    extractedText = text
    state = .review
}

func reset() {
    extractedText = ""
    state = .idle
}
}

