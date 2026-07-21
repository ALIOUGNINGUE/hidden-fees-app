//
//  HistoryView.swift
//  Hidden Fee App
//
//  Created by Apple on 7/20/26.
//


//
//  HistoryView.swift
//  Hidden Fee App
//
//  History tab — shows past scans. Currently a placeholder; wire up
//  real persisted scan records (e.g. SwiftData/CoreData) when ready.
//

import SwiftUI

struct HistoryView: View {
    // Replace with real persisted scan records when you have a model for them.
    @State private var historyItems: [ScanHistoryItem] = []

    var body: some View {
        NavigationStack {
            Group {
                if historyItems.isEmpty {
                    emptyState
                } else {
                    List(historyItems) { item in
                        HStack(spacing: 14) {
                            Image(systemName: item.docType.iconName)
                                .foregroundStyle(item.docType.accentColor)
                                .frame(width: 28, height: 28)
                                .background(item.docType.accentColor.opacity(0.18), in: RoundedRectangle(cornerRadius: 8))

                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.docType.name)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.white)
                                Text(item.scannedAt.formatted(date: .abbreviated, time: .shortened))
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                        }
                        .listRowBackground(Color.white.opacity(0.06))
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.black)
                }
            }
            .navigationTitle("History")
            .background(Color.black.ignoresSafeArea())
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 40))
                .foregroundStyle(.gray)
            Text("No scans yet")
                .font(.headline)
                .foregroundStyle(.white)
            Text("Documents you scan will show up here")
                .font(.subheadline)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

/// Minimal placeholder model for a past scan. Swap for your real
/// persisted model (SwiftData @Model, CoreData entity, etc.) later.
struct ScanHistoryItem: Identifiable {
    let id = UUID()
    let docType: DocumentType
    let scannedAt: Date
    let extractedText: String
}

#Preview {
    HistoryView()
}