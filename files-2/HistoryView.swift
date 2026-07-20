//
//  HistoryView.swift
//  Hidden Fee App
//
//  History tab: browse, search, and filter past scans.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \ScanHistoryEntry.createdAt, order: .reverse) private var entries: [ScanHistoryEntry]
    @Environment(\.modelContext) private var context

    @State private var searchText = ""
    @State private var selectedDocumentTypeID: String?

    private var filteredEntries: [ScanHistoryEntry] {
        entries.filter { entry in
            let matchesType = selectedDocumentTypeID == nil || entry.documentTypeID == selectedDocumentTypeID
            let matchesSearch = searchText.isEmpty
                || (DocumentType.allTypes.first(where: { $0.id == entry.documentTypeID })?.name
                    .localizedCaseInsensitiveContains(searchText) ?? false)
            return matchesType && matchesSearch
        }
    }

    private var groupedByMonth: [(month: String, entries: [ScanHistoryEntry])] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"

        let groups = Dictionary(grouping: filteredEntries) { formatter.string(from: $0.createdAt) }
        return groups
            .sorted { lhs, rhs in
                let lhsDate = groups[lhs.key]?.first?.createdAt ?? .distantPast
                let rhsDate = groups[rhs.key]?.first?.createdAt ?? .distantPast
                return lhsDate > rhsDate
            }
            .map { (month: $0.key, entries: $0.value) }
    }

    var body: some View {
        NavigationStack {
            Group {
                if entries.isEmpty {
                    emptyState
                } else {
                    list
                }
            }
            .navigationTitle("History")
            .searchable(text: $searchText, prompt: "Search by document type")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    filterMenu
                }
            }
        }
    }

    private var list: some View {
        List {
            ForEach(groupedByMonth, id: \.month) { group in
                Section(group.month) {
                    ForEach(group.entries) { entry in
                        NavigationLink {
                            HistoryDetailView(entry: entry)
                        } label: {
                            HistoryRow(entry: entry)
                        }
                    }
                    .onDelete { offsets in
                        delete(offsets: offsets, from: group.entries)
                    }
                }
            }
        }
    }

    private var emptyState: some View {
        ContentUnavailableView(
            "No Scans Yet",
            systemImage: "doc.text.viewfinder",
            description: Text("Documents you scan will show up here with their fee findings.")
        )
    }

    private var filterMenu: some View {
        Menu {
            Button("All Documents") { selectedDocumentTypeID = nil }
            Divider()
            ForEach(DocumentType.allTypes) { docType in
                Button {
                    selectedDocumentTypeID = docType.id
                } label: {
                    Label(docType.name, systemImage: docType.iconName)
                }
            }
        } label: {
            Image(systemName: selectedDocumentTypeID == nil
                  ? "line.3.horizontal.decrease.circle"
                  : "line.3.horizontal.decrease.circle.fill")
        }
    }

    private func delete(offsets: IndexSet, from groupEntries: [ScanHistoryEntry]) {
        for index in offsets {
            context.delete(groupEntries[index])
        }
        try? context.save()
    }
}

// MARK: - Row

struct HistoryRow: View {
    let entry: ScanHistoryEntry

    private var documentType: DocumentType? {
        DocumentType.allTypes.first { $0.id == entry.documentTypeID }
    }

    var body: some View {
        HStack(spacing: 12) {
            iconBadge

            VStack(alignment: .leading, spacing: 4) {
                Text(documentType?.name ?? "Unknown Document")
                    .font(.headline)
                Text(entry.createdAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                findingsSummary
            }

            Spacer()

            severityBadge
        }
        .padding(.vertical, 4)
    }

    private var iconBadge: some View {
        Image(systemName: documentType?.iconName ?? "doc.questionmark")
            .font(.title3)
            .foregroundStyle(.white)
            .frame(width: 36, height: 36)
            .background(documentType?.accentColor ?? .gray, in: Circle())
    }

    private var findingsSummary: some View {
        Text(entry.findings.isEmpty
             ? "No hidden fee terms found"
             : "\(entry.findings.count) finding\(entry.findings.count == 1 ? "" : "s")")
            .font(.caption)
            .foregroundStyle(.secondary)
    }

    private var severityBadge: some View {
        let severity = entry.highestSeverity
        return Text(severity.rawValue.capitalized)
            .font(.caption2.bold())
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(severity.color.opacity(0.2), in: Capsule())
            .foregroundStyle(severity.color)
            .opacity(entry.findings.isEmpty ? 0 : 1)
    }
}
