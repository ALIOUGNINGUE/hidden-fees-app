//
//  ScannerViewModel.swift
//  Hidden Fee App
//
//  Created by Everyone Can Code Chicago on 7/6/26.
//

import SwiftUI

@Observable
@MainActor
final class ScannerViewModel {
    enum State: Equatable {
        case idle
        case processing
        case review
        case failed(String)
    }
    
    var state: State = .idle
    var extractedText: String = ""
    var report: ScanReport?
    
    
    func analyze(text: String, documentType: DocumentType) async {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            state = .failed("No text was found in the document.")
            return
        }
        
        state = .processing
        extractedText = text
        
        let chunks = chunkDocument(text)
        
        
        let orchestrator = PipelineOrchestrator(documentType: documentType)
        let result = await orchestrator.process(chunks: chunks)
        
        report = result
        state = .review
    }
    
    func reset() {
        extractedText = ""
        report = nil
        state = .idle
    }
    
    
    func loadSampleText(_ text: String) {
        extractedText = text
        state = .review
    }
}
