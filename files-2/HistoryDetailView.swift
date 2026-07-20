//
//  HistoryDetailView.swift
//  Hidden Fee App
//
//  Full report view for a single saved scan. Uses the shared FindingRow
//  (see FindingRow.swift) so saved scans look identical to freshly
//  generated ones in ResultsView.
//

import SwiftUI
import SwiftData

struct HistoryDetailView: View {
    let entry: ScanHistoryEntry
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var showingDeleteConfirmation = false

    private var report: ScanReport? {
        entry.makeReport()
    }

    var body: some View {
        Group {
            if let report {
                List {
                    Section {
                        header(for: report)
                    }

                    if report.findings.isEmpty {
                        Section {
                            Text(report.summaryLine)
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        Section("Findings") {
                            ForEach(report.sortedFindings) { finding in
                                FindingRow(finding: finding)
                            }
                        }
                    }
                }
            } else {
                ContentUnavailableView(
                    "Can't Load This Scan",
                    systemImage: "exclamationmark.triangle",
                    description: Text("This document type may no longer be supported.")
                )
            }
        }
        .navigationTitle(report?.documentType.name ?? "Scan")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(role: .destructive) {
                    showingDeleteConfirmation = true
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
        .confirmationDialog(
            "Delete this scan?",
            isPresented: $showingDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                context.delete(entry)
                try? context.save()
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        }
    }

    private func header(for report: ScanReport) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(report.createdAt.formatted(date: .long, time: .shortened))
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(report.summaryLine)
                .font(.body)
        }
    }
}
