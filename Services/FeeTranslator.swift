//
//  FeeTranslator.swift
//  Hidden Fee App
//
//  Created by Everyone Can Code Chicago on 7/14/26.
//

import SwiftUI
import FoundationModels

@Generable
struct TranslationResult {
    @Guide(description: "One plain sentence a high school student would understand, stating the specific consequence or cost")
    var plainEnglish: String
}
struct FeeTranslator {
    
    private let model: SystemLanguageModel
    private let translatorInstructions: String
    
    init() {
        self.model = SystemLanguageModel(guardrails: .permissiveContentTransformations)
        self.translatorInstructions = """
                    You rewrite confusing contract sentences into plain English. \
                    Keep it to one sentence a high school student would understand. \
                    State the specific consequence or cost clearly. Keep any numbers, \
                    percentages, and dollar amounts exactly as they appear. Do not add \
                    warnings or opinions — just explain what the sentence means.
                    """
    }
    
    func translate(_ sentence: String) async throws -> String {
        let session = LanguageModelSession(
            model: model,
            instructions: translatorInstructions
        )
        
        let options = GenerationOptions(
            sampling: .greedy,
            temperature: 0.3,
            maximumResponseTokens: 60
        )
        
        let response = try await session.respond(
            to: "Rewrite this sentence in plain English: \(sentence)",
            generating: TranslationResult.self,
            options: options
        )
        
        return JargonCleaner.clean(response.content.plainEnglish)
    }
}
 

