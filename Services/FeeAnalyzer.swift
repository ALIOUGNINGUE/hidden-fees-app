//
//  FeeAnalyzer.swift
//  Hidden Fee App
//
//  Created by Everyone Can Code Chicago on 7/14/26.
//

import SwiftUI
import FoundationModels

struct FeeAnalyzer {
    
    let documentType: String
    private let translator = FeeTranslator()
    private let guardedModel: SystemLanguageModel
    private let unguardedModel: SystemLanguageModel
    private let filterInstructions: String
    
    init(documentType: String) {
        self.documentType = documentType
        self.guardedModel = SystemLanguageModel.default
        self.unguardedModel = SystemLanguageModel(guardrails: .permissiveContentTransformations)
        self.filterInstructions = "You help students identify confusing language in texts."
    }
    
    /// Returns a FlaggedFee if the sentence is hidden, nil if clear.
    func analyze(sentence: String, context: String) async -> FlaggedFee? {
        
        // Step 1: guarded filter on the original
        do {
            let verdict = try await runGuardedFilter(text: sentence, context: context)
            if verdict {
                return FlaggedFee(originalText: sentence, plainText: nil, chunkIndex: 0, source: .aiJudged)
            } else {
                return nil
            }
        } catch {
            // Guarded filter refused — fall through to translation path
        }
        
        // Step 2: translate with the unguarded model
        guard let plainEnglish = try? await translator.translate(sentence) else {
            return FlaggedFee(originalText: sentence, plainText: nil, chunkIndex: 0, source: .guardrailRefused)
        }
        
        // Step 3: guarded filter on the translation
        do {
            let verdict = try await runGuardedFilter(text: plainEnglish, context: plainEnglish)
            return verdict
                ? FlaggedFee(originalText: sentence, plainText: plainEnglish, chunkIndex: 0, source: .aiJudged)
                : nil
        } catch {
            // Step 4: guarded still refused — last resort, unguarded verdict
            let verdict = (try? await runUnguardedFilter(text: plainEnglish)) ?? true
            return verdict
                ? FlaggedFee(originalText: sentence, plainText: plainEnglish, chunkIndex: 0, source: .guardrailRefused)
                : nil
        }
    }
    
    private func runGuardedFilter(text: String, context: String) async throws -> Bool {
        let session = LanguageModelSession(
            model: guardedModel,
            instructions: filterInstructions
        )
        
        let cleanContext = TextSanitizer.sanitize(context)
        let cleanSentence = TextSanitizer.sanitize(text)
        
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
        
        let response = try await session.respond(
            to: prompt,
            generating: HiddenFeeVerdict.self
        )
        return !response.content.isClear
    }
    
    private func runUnguardedFilter(text: String) async throws -> Bool {
        let session = LanguageModelSession(
            model: unguardedModel,
            instructions: filterInstructions
        )
        
        let prompt = """
        Would a typical reader understand the full consequences of this \
        sentence? Return true if clear. Return false if it hides important \
        consequences.
        
        Sentence: \(text)
        """
        
        let response = try await session.respond(
            to: prompt,
            generating: HiddenFeeVerdict.self
        )
        return !response.content.isClear
    }
}
