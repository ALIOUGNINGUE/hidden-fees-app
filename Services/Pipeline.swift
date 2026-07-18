import Foundation

struct PipelineOrchestrator {
    
    private let translator: FeeTranslator
    private let categorizer: FeeCategorizer
    private let documentType: DocumentType
    
    init(documentType: DocumentType) {
        self.documentType = documentType
        self.translator = FeeTranslator()
        self.categorizer = FeeCategorizer()
    }
    
    func process(chunks: [DocumentChunk]) async -> ScanReport {
        var findings: [Finding] = []
        
        for chunk in chunks {
            let sentences = SentenceSplitter.split(chunk: chunk)
            
            for sentence in sentences {
                
                // Skip headings
                if HeadingDetector.isHeading(sentence) {
                    print("SKIPPED (heading): \(sentence.prefix(50))")
                    continue
                }
                
                // Skip sentences with no cost signal at all
                if !hasCostSignal(sentence) {
                    print("SKIPPED (no cost signal): \(sentence.prefix(50))")
                    continue
                }
                
                // DETECTION = pure keyword match, no AI, deterministic
                let categories = categorizer.categorizeByKeywords(
                    originalText: sentence,
                    plainText: sentence,
                    documentType: documentType
                )
                
                guard !categories.isEmpty else {
                    print("SKIPPED (no category): \(sentence.prefix(50))")
                    continue
                }
                print("FLAGGED [\(categories.map { $0.displayName }.joined(separator: "+"))]: \(sentence.prefix(50))")
                
                // Translate for display
                let plainText: String
                do {
                    plainText = try await translator.translate(sentence)
                } catch {
                    plainText = sentence
                }
                
                // Re-categorize using both original and translation for accuracy
                let finalCategories = categorizer.categorizeByKeywords(
                    originalText: sentence,
                    plainText: plainText,
                    documentType: documentType
                )
                
                let severity = SeverityLevel.calculate(from: finalCategories)
                
                let finding = Finding(
                    originalText: sentence,
                    plainEnglish: plainText,
                    categories: finalCategories,
                    severity: severity,
                    source: .aiJudged,
                    chunkIndex: chunk.originalIndex
                )
                
                findings.append(finding)
            }
        }
        
        return ScanReport(documentType: documentType, findings: findings)
    }
    
    /// Quick check: does this sentence mention anything cost-related at all?
    private func hasCostSignal(_ text: String) -> Bool {
        let signals = ["fee", "charge", "cost", "pay", "rate", "percent",
                       "%", "$", "penalty", "interest", "renew", "cancel",
                       "terminate", "default", "deposit", "owe", "due",
                       "balance", "increase", "surcharge", "bill"]
        let lowered = text.lowercased()
        return signals.contains { lowered.contains($0) }
    }
}
