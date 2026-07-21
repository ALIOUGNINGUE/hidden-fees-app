//
//  GlossaryView.swift
//  Hidden Fee App
//
//  Created by Apple on 7/20/26.
//

import SwiftUI

struct GlossaryView: View {
    @State private var searchText = ""

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
        ),
        GlossaryTerm(
            term: "Deferred Interest",
            definition: "Interest that builds up during a promotional period. If you don't pay in full by the deadline, you owe all of it retroactively."
        ),
        GlossaryTerm(
            term: "Capitalized Interest",
            definition: "Unpaid interest that gets added to your loan balance, so you start paying interest on your interest."
        ),
        GlossaryTerm(
            term: "Early Termination Fee",
            definition: "A charge for canceling a contract before it expires, sometimes equal to several months of payments."
        ),
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
            ScrollView {
                if filteredTerms.isEmpty {
                    VStack(spacing: 14) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 40))
                            .foregroundStyle(.secondary)
                        Text("No results for \"\(searchText)\"")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 60)
                } else {
                    VStack(spacing: 10) {
                        ForEach(filteredTerms) { item in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(item.term)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.white)
                                Text(item.definition)
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                                    .lineSpacing(3)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 14))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 40)
                }
            }
            .background(Color.black)
            .navigationTitle("Glossary")
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .searchable(text: $searchText, prompt: "Search terms")
        }
        .preferredColorScheme(.dark)
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
