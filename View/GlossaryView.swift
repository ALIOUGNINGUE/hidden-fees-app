//
//  GlossaryView.swift
//  Hidden Fee App
//
//  Created by Apple on 7/20/26.
//


//
//  GlossaryView.swift
//  Hidden Fee App
//
//  Glossary tab — plain-language definitions for terms users will see
//  flagged in their documents (APR, penalty rate, etc).
//

import SwiftUI

struct GlossaryView: View {
    @State private var searchText = ""

    // Starter set — expand or load from a JSON/plist asset as it grows.
    private let terms: [GlossaryTerm] = [
        GlossaryTerm(
            term: "Annual Percentage Rate (APR)",
            definition: "The yearly cost of borrowing, including interest, shown as a percentage."
        ),
        GlossaryTerm(
            term: "Penalty APR",
            definition: "A higher interest rate that can kick in if you miss a payment or break the account terms."
        ),
        GlossaryTerm(
            term: "Introductory Rate",
            definition: "A temporary lower rate offered for a limited time, which later reverts to the standard rate."
        ),
        GlossaryTerm(
            term: "Minimum Finance Charge",
            definition: "The smallest interest fee you'll be charged in a billing cycle if you carry a balance."
        ),
        GlossaryTerm(
            term: "Grace Period",
            definition: "The window after your statement closes where you can pay in full and avoid interest."
        )
    ]

    private var filteredTerms: [GlossaryTerm] {
        guard !searchText.isEmpty else { return terms }
        return terms.filter {
            $0.term.localizedCaseInsensitiveContains(searchText) ||
            $0.definition.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            List(filteredTerms) { item in
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.term)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                    Text(item.definition)
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                .padding(.vertical, 4)
                .listRowBackground(Color.white.opacity(0.06))
            }
            .scrollContentBackground(.hidden)
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("Glossary")
            .searchable(text: $searchText, prompt: "Search terms")
        }
    }
}

struct GlossaryTerm: Identifiable {
    let id = UUID()
    let term: String
    let definition: String
}

#Preview {
    GlossaryView()
}