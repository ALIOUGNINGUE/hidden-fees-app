//
//  HiddenFeeFilter.swift
//  Hidden Fee App
//
//  Created by Everyone Can Code Chicago on 7/9/26.
//
import FoundationModels

@Generable
struct HiddenFeeVerdict {
    @Guide(description: "true if the meaning is clear and obvious, false if the sentence hides important consequences or downplays its impact")
    var isClear: Bool
}

struct HiddenFeeFilter {
    
    let documentType: String
    private let model: SystemLanguageModel
    private let filterInstructions: String
    
    init(documentType: String) {
        self.documentType = documentType
        self.model = SystemLanguageModel.default
        self.filterInstructions = """
        You are a consumer financial literacy tool that helps people understand \
        contract language. Your only job is to evaluate whether a sentence from \
        a financial document is written clearly enough for a typical reader to \
        understand its full consequences. This is educational analysis only.
        """
    }
    
    func evaluate(sentence: String, context: String) async throws -> FlaggedFee? {
        // Fresh session per call — keeps evaluations independent
        let session = LanguageModelSession(
            model: model,
            instructions: filterInstructions
        )
        
        let cleanContext = TextSanitizer.sanitize(context)
        let cleanSentence = TextSanitizer.sanitize(sentence)
        
        let prompt = """
        Here is a paragraph from a contract:
        \(cleanContext)
        
        Focus on this specific sentence:
        \(cleanSentence)
        
        Would a typical reader understand the full consequences \
        of the focused sentence, considering the context of the \
        surrounding paragraph? Return true if the meaning and \
        impact are clear and obvious. Return false if the sentence \
        hides important consequences, downplays its impact, or \
        contributes to a pattern that obscures the full impact when \
        read together with the other sentences.
        """
        
        do {
            let response = try await session.respond(
                to: prompt,
                generating: HiddenFeeVerdict.self
            )
            if response.content.isClear {
                return nil
            }
            return FlaggedFee(originalText: sentence, plainText: sentence, chunkIndex: 0, source: .aiJudged)
        } catch LanguageModelSession.GenerationError.refusal {
            return FlaggedFee(originalText: sentence, plainText: sentence, chunkIndex: 0, source: .guardrailRefused)
        }
    }
}
