//
//  FindingRow.swift
//  Hidden Fee App
//
//  Shared row UI for a single `Finding`, used by both the freshly-generated
//  results screen and the saved history detail screen so they stay visually
//  consistent.
//

import SwiftUI

struct FindingRow: View {
    let finding: Finding
    @State private var isExpanded = false

    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            VStack(alignment: .leading, spacing: 8) {
                Text(finding.originalText)
                    .font(.callout)
                    .italic()
                    .foregroundStyle(.secondary)

                if let whyItMatters = finding.whyItMatters {
                    Text(whyItMatters)
                        .font(.callout)
                }

                if let questionToAsk = finding.questionToAsk {
                    Label(questionToAsk, systemImage: "questionmark.bubble")
                        .font(.callout)
                }

                if !finding.categories.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(finding.categories) { category in
                                Text(category.displayName)
                                    .font(.caption2)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(.gray.opacity(0.15), in: Capsule())
                            }
                        }
                    }
                }
            }
            .padding(.top, 4)
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text(finding.plainEnglish)
                    .font(.subheadline.weight(.medium))
                HStack(spacing: 6) {
                    Circle()
                        .fill(finding.severity.color)
                        .frame(width: 8, height: 8)
                    Text(finding.severity.label)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
