//
//  HistoryView.swift
//  Hidden Fee App
//
//  Created by Apple on 7/20/26.
//

import SwiftUI

struct HistoryView: View {
    @Environment(ScanHistory.self) private var scanHistory

    var body: some View {
        NavigationStack {
            Group {
                if scanHistory.reports.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(scanHistory.reports) { report in
                                NavigationLink {
                                    ResultsView(report: report)
                                } label: {
                                    HistoryRow(report: report)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationTitle("History")
            .background(Color.black.ignoresSafeArea())
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .preferredColorScheme(.dark)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("No scans yet")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)
            Text("Documents you scan will appear here.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - History Row

private struct HistoryRow: View {
    let report: ScanReport

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: report.documentType.iconName)
                .font(.title3)
                .foregroundStyle(report.documentType.accentColor)
                .frame(width: 44, height: 44)
                .background(report.documentType.accentColor.opacity(0.15), in: RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 5) {
                Text(report.documentType.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)

                Text(report.createdAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)

                if !report.findings.isEmpty {
                    HStack(spacing: 6) {
                        ForEach([SeverityLevel.high, .medium, .low], id: \.self) { level in
                            if let count = report.severityCounts[level], count > 0 {
                                Text("\(count) \(level.shortLabel)")
                                    .font(.caption2.weight(.semibold))
                                    .foregroundStyle(level.color)
                                    .padding(.horizontal, 7)
                                    .padding(.vertical, 3)
                                    .background(level.color.opacity(0.12), in: Capsule())
                            }
                        }
                    }
                } else {
                    Text("No issues found")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.green)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(Color.green.opacity(0.12), in: Capsule())
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .background(Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.08), lineWidth: 1))
    }
}

#Preview {
    HistoryView()
        .environment(ScanHistory())
}
