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
            VStack(alignment: .leading, spacing: 20) {
                summaryHeader

                if report.findings.isEmpty {
                    emptyFindings
                } else {
                    VStack(spacing: 10) {
                        ForEach(report.sortedFindings) { finding in
                            NavigationLink {
                                FindingDetailView(finding: finding)
                            } label: {
                                FindingCard(finding: finding)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 40)
        }
        .background(Color.black)
        .preferredColorScheme(.dark)
        .navigationTitle(report.documentType.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.black, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    // MARK: - Summary header

    private var summaryHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(report.findings.isEmpty ? "All clear" : "\(report.findings.count) issue\(report.findings.count == 1 ? "" : "s") flagged")
                .font(.title2.weight(.bold))
                .foregroundStyle(.white)

            if !report.findings.isEmpty {
                HStack(spacing: 8) {
                    ForEach([SeverityLevel.high, .medium, .low], id: \.self) { level in
                        if let count = report.severityCounts[level], count > 0 {
                            HStack(spacing: 5) {
                                Circle()
                                    .fill(level.color)
                                    .frame(width: 7, height: 7)
                                Text("\(count) \(level.shortLabel)")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(level.color)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(level.color.opacity(0.12), in: Capsule())
                        }
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.08), lineWidth: 1))
    }

    private var emptyFindings: some View {
        VStack(spacing: 14) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 48))
                .foregroundStyle(.green)
            Text("No hidden fees detected")
                .font(.headline)
                .foregroundStyle(.white)
            Text("We didn't find any flagged terms. Still review the full document carefully.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(28)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Finding Card (summary row)

private struct FindingCard: View {
    let finding: Finding

    var body: some View {
        HStack(spacing: 0) {
            // Colored severity accent bar
            Rectangle()
                .fill(finding.severity.color)
                .frame(width: 3)

            HStack(alignment: .top, spacing: 10) {
                VStack(alignment: .leading, spacing: 7) {
                    HStack(alignment: .top) {
                        Text(finding.categories.map { $0.displayName }.joined(separator: " · "))
                            .font(.caption.weight(.bold))
                            .foregroundStyle(finding.severity.color)
                            .lineLimit(1)
                        Spacer()
                        Text(finding.severity.shortLabel)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(finding.severity.color)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(finding.severity.color.opacity(0.12), in: Capsule())
                    }
                    Text(finding.plainEnglish)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                        .multilineTextAlignment(.leading)
                        .lineSpacing(2)
                }
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .padding(.top, 2)
            }
            .padding(14)
        }
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - Finding Detail (subpage)

struct FindingDetailView: View {
    let finding: Finding

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // Severity badge
                HStack {
                    Spacer()
                    Text(finding.severity.label)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(finding.severity.color)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(finding.severity.color.opacity(0.12), in: Capsule())
                }

                // Contract context block
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(finding.contextBefore, id: \.self) { sentence in
                        Text(sentence)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                    }

                    // Flagged sentence with colored left border
                    HStack(spacing: 0) {
                        Rectangle()
                            .fill(finding.severity.color)
                            .frame(width: 3)
                        Text(finding.originalText)
                            .font(.callout.weight(.medium))
                            .foregroundStyle(.white)
                            .lineSpacing(3)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .background(finding.severity.color.opacity(0.1))

                    ForEach(finding.contextAfter, id: \.self) { sentence in
                        Text(sentence)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                    }
                }
                .background(Color.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 16))
                .clipShape(RoundedRectangle(cornerRadius: 16))

                // Plain English explanation
                VStack(alignment: .leading, spacing: 8) {
                    Label("What this means", systemImage: "text.bubble")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                        .tracking(0.5)
                    Text(finding.plainEnglish)
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .lineSpacing(3)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 16))

                // Category definitions
                if !finding.categories.isEmpty {
                    VStack(alignment: .leading, spacing: 14) {
                        Label("Categories", systemImage: "tag")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.secondary)
                            .textCase(.uppercase)
                            .tracking(0.5)
                        ForEach(finding.categories) { category in
                            VStack(alignment: .leading, spacing: 5) {
                                Text(category.displayName)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.white)
                                Text(category.definition)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineSpacing(2)
                            }
                        }
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 40)
        }
        .background(Color.black)
        .preferredColorScheme(.dark)
        .navigationTitle(finding.categories.first?.displayName ?? "Finding")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.black, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}
