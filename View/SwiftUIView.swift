import SwiftUI
import FoundationModels

struct ContentView: View {
    var body: some View {
        Text("Check the console")
            .onAppear {
                Task {
                    let filter = HiddenFeeFilter(documentType: "credit card")
                    let chunk = OCRStub.fakeCreditCardChunks()[0]
                    
                    let sentences = SentenceSplitter.split(chunk: chunk)
                    print("Sentence count: \(sentences.count)")
                    
                    for i in 0..<sentences.count {
                        let start = max(0, i - 2)
                        let end = min(sentences.count - 1, i + 2)
                        let context = sentences[start...end].joined(separator: "\n")
                        let sentence = sentences[i]
                        
                        do {
                            let isHidden = try await filter.evaluate(
                                sentence: sentence,
                                context: context
                            )
                           // print("\(isHidden ? "HIDDEN" : "CLEAR "):  \(sentence.prefix(80))")
                        } catch {
                            print("ERROR: \(error)\n  sentence: \(sentence.prefix(80))")
                        }
                    }
                }
            }
    }
}
