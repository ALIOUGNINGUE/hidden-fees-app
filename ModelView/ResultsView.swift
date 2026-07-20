//
//  ResultsView.swift
//  Hidden Fee App
//
//  Created by Everyone Can Code Chicago on 7/20/26.
//

import SwiftUI

struct ResultsView: View {
    let report: ScanReport

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(report.summaryLine)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.top, 8)

                ForEach(report.sortedFindings) { finding in
                    FindingCard(finding: finding)
                }
            }
            .padding()
        }
        .background(Color.black)
        .preferredColorScheme(.dark)
    }
}

private struct FindingCard: View {
    let finding: Finding

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(finding.categories.map { $0.displayName }.joined(separator: " + "))
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.white)
                Spacer()
                Text(finding.severity.label)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(finding.severity.color)
            }

            Text(finding.plainEnglish)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.9))

            Text(finding.originalText)
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.top, 2)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 14))
    }
}
