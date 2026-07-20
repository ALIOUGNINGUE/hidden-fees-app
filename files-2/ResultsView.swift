//
//  ResultsView.swift
//  Hidden Fee App
//
//  Fulfills the flow that DocumentUploadView starts: takes the raw OCR'd
//  text for a document, runs it through the real pipeline
//  (chunkDocument -> PipelineOrchestrator), displays the resulting
//  ScanReport, and saves it to history — all in one place, so "what the
//  user sees right after scanning" and "what's in history" can never
//  drift apart.
//

import SwiftUI
import SwiftData

struct ResultsView: View {
    let docType: DocumentType
    let rawText: String

    @Environment(\.modelContext) private var context

    @State private var report: ScanReport?
    @State private var isProcessing = true
    @State private var hasSaved = false

    var body: some View {
        Group {
            if isProcessing {
                processingState
            } else if let report {
                reportContent(report)
            } else {
                ContentUnavailableView(
                    "Something Went Wrong",
                    systemImage: "exclamationmark.triangle",
                    description: Text("We couldn't analyze this document. Try scanning it again.")
                )
            }
        }
        .navigationTitle(docType.name)
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .task {
            await runPipeline()
        }
    }

    private var processingState: some View {
        VStack(spacing: 16) {
            ProgressView()
                .controlSize(.large)
            Text("Scanning for hidden fees…")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func reportContent(_ report: ScanReport) -> some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text(report.summaryLine)
                        .font(.body)
                }
            }

            if !report.findings.isEmpty {
                Section("Findings") {
                    ForEach(report.sortedFindings) { finding in
                        FindingRow(finding: finding)
                    }
                }
            }
        }
    }

    private func runPipeline() async {
        let chunks = chunkDocument(rawText)
        let orchestrator = PipelineOrchestrator(documentType: docType)
        let result = await orchestrator.process(chunks: chunks)

        report = result
        isProcessing = false

        saveToHistory(result)
    }

    /// Guards against double-saving if `.task` were ever re-triggered
    /// (e.g. view identity changes) — the pipeline itself is not idempotent
    /// to call twice for the same scan.
    private func saveToHistory(_ report: ScanReport) {
        guard !hasSaved else { return }
        hasSaved = true

        let entry = ScanHistoryEntry(report: report)
        context.insert(entry)
        try? context.save()
    }
}
