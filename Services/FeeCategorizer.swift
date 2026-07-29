import SwiftUI
import FoundationModels
struct CategorizationResult {
    let categories: [FeeCategory]
}

@Generable
struct CategoryResult {
    @Guide(description: "The ID of the category that best fits the sentence")
    var categoryId: String
}

@Generable
struct CategoryMatch {
    @Guide(description: "true if the sentence involves this category, false if it does not")
    var matches: Bool
}

struct FeeCategorizer {
        private let costSignalRequired: Set<String> = [
            "cash_advance_fee",
            "balance_transfer_fee",
            "foreign_transaction_fee",
        ]
        private func hasCostMarker(_ text: String) -> Bool {
            let markers = ["$", "%", " fee", " fees", " charge", " charging",
                           " charged", " interest", "whichever is greater"]
            return markers.contains { text.contains($0) }
        }
    private let model: SystemLanguageModel
    
    init() {
        self.model = SystemLanguageModel(guardrails: .permissiveContentTransformations)
    }
    
    func categorize(
        originalText: String,
        plainText: String,
        documentType: DocumentType
    ) async -> [FeeCategory] {
        
        let searchText = (JargonCleaner.clean(originalText) + " " + plainText).lowercased()
        
        // Step 1: weighted keyword scoring
        var candidates: [(category: FeeCategory, score: Int)] = []
        
        for category in documentType.categories {
            var score = 0
            for (word, weight) in category.keywords {
                if searchText.contains(word.lowercased()) {
                    score += weight
                }
            }
            if score >= category.threshold {
                candidates.append((category, score))
            }
        }
        
        if candidates.isEmpty {
            if let single = await aiFallbackSingle(
                plainText: plainText,
                candidates: documentType.categories
            ) {
                return [single]
            }
            return [.junkFee]
        }
        
        if candidates.count == 1 {
            return [candidates[0].category]
        }
        
        // Step 2: multiple candidates — AI confirms each
        var confirmed: [FeeCategory] = []
        
        for candidate in candidates {
            let belongs = await confirmCategory(
                plainText: plainText,
                category: candidate.category
            )
            if belongs {
                confirmed.append(candidate.category)
            }
        }
        
        if confirmed.isEmpty {
            candidates.sort { $0.score > $1.score }
            return [candidates[0].category]
        }
        
        return confirmed
    }

        private func isExplanatoryOrProtective(_ text: String) -> Bool {
            let lowered = text.lowercased()
            
            let protectivePhrases = [
                "how to avoid",
                "avoid paying",
                "will not pay",
                "will not charge",
                "we will not",
                "no interest if",
                "to learn more",
                "tips from",
                "your billing rights",
                "billing rights",
                "if you think there is an error",
                "you find a mistake",
                "we will investigate",
                "we will research",
                "you may request a refund",
                "we will reimburse",
                "you have the right to reject",
                "you have the right to",
                "you can regain",
                "you can pay down balances faster",
                "contact us in writing",
                "we must tell you",
                "you do not have to pay the first $50",
                "we do not permit",
                "do not permit",
                "we do not allow",
                "not permitted",
                "may not use",
                "applicable law may restrict",
                "see the rates and fees table",
                "table above",
                "indicates amounts",
            ]
            if protectivePhrases.contains(where: { lowered.contains($0) }) {
                return true
            }
            
            let mentionsTransactionType = lowered.contains("balance transfer")
                || lowered.contains("cash advance")
            let looksLikeRate = lowered.contains("apr")
            let looksLikeFee = lowered.contains("$")
                || lowered.contains("whichever is greater")
                || lowered.contains("either")
            
            if mentionsTransactionType && looksLikeRate && !looksLikeFee {
                return true
            }
            
            return false
        }
    func categorizeByKeywords(
            originalText: String,
            plainText: String,
            documentType: DocumentType
        ) -> [FeeCategory] {

            let searchText = (JargonCleaner.clean(originalText) + " " + plainText).lowercased()

            // Rough sub-sentence split of the original, for scoped suppression.
            let subSentences = originalText
                .components(separatedBy: CharacterSet(charactersIn: ".!?\n"))
                .map { $0.trimmingCharacters(in: .whitespaces).lowercased() }
                .filter { !$0.isEmpty }

            var candidates: [(category: FeeCategory, score: Int)] = []

            for category in documentType.categories {
                var score = 0
                var matchedWords: [String] = []
                for (word, weight) in category.keywords {
                    if searchText.contains(word.lowercased()) {
                        score += weight
                        matchedWords.append(word.lowercased())
                    }
                }
                guard score >= category.threshold else { continue }

                // Transaction-type categories still need a real cost marker
                if costSignalRequired.contains(category.id) && !hasCostMarker(searchText) {
                    continue
                }

                // Scoped suppression: drop this category only if EVERY sub-sentence
                // that carries one of its keywords is explanatory/protective.
                let carrying = subSentences.filter { s in
                    matchedWords.contains { s.contains($0) }
                }
                if !carrying.isEmpty && carrying.allSatisfy({ isExplanatoryOrProtective($0) }) {
                    continue
                }

                candidates.append((category, score))
            }

            guard !candidates.isEmpty else { return [] }
            candidates.sort { $0.score > $1.score }
            return candidates.map { $0.category }
        }
    private func confirmCategory(
        plainText: String,
        category: FeeCategory
    ) async -> Bool {
        let session = LanguageModelSession(
            model: model,
            instructions: "You answer yes or no questions about contract terms."
        )
        
        do {
            let prompt = """
            Does this sentence involve \(category.displayName)?
            Definition: \(category.definition)
            
            Sentence: \(plainText)
            
            Return true if yes, false if no.
            """
            
            let response = try await session.respond(
                to: prompt,
                generating: CategoryMatch.self
            )
            return response.content.matches
        } catch {
            // If AI can't answer, trust the keyword match
            return true
        }
    }
    
    private func aiFallbackSingle(
        plainText: String,
        candidates: [FeeCategory]
    ) async -> FeeCategory? {
        let categoryList = candidates
            .map { "\($0.id): \($0.displayName) — \($0.definition)" }
            .joined(separator: "\n")
        
        let session = LanguageModelSession(
            model: model,
            instructions: "You classify sentences into exactly one category."
        )
        
        do {
            let prompt = """
            Which one of these categories best fits this sentence?
            
            \(categoryList)
            
            Sentence: \(plainText)
            
            Return only the category ID.
            """
            
            let response = try await session.respond(
                to: prompt,
                generating: CategoryResult.self
            )
            
            return candidates.first { $0.id == response.content.categoryId }
        } catch {
            return nil
        }
    }
}
