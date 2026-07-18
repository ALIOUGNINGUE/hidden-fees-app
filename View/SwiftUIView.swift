import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Check the console")
            .onAppear {
                Task {
                    let pipeline = PipelineOrchestrator(
                        documentType: .creditCard
                    )
                    let chunks = OCRStub.fakeCreditCardChunks()
                    
                    print("=== RUNNING FULL PIPELINE ===")
                    print("Chunks: \(chunks.count)")
                    print("")
                    
                    let report = await pipeline.process(chunks: chunks)
                    
                    print("=== SCAN REPORT ===")
                    print(report.summaryLine)
                    print("")
                    
                    for finding in report.sortedFindings {
                        let categoryNames = finding.categories
                            .map { $0.displayName }
                            .joined(separator: " + ")
                        print("\(finding.severity.label)")
                        print("Categories: \(categoryNames)")
                        print("Original:  \(finding.originalText.prefix(70))")
                        print("Plain:     \(finding.plainEnglish.prefix(70))")
                        print("Source:    \(finding.source)")
                        print("---")
                    }
                    
                    print("=== DONE ===")
                }
            }
    }
}
