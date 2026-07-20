//
//  ScanHistoryEntry.swift
//  Hidden Fee App
//
//  Persisted history record for completed scans. `ScanReport` isn't itself
//  persistable — `DocumentType` carries a `Color` and `FeeCategory` isn't
//  Codable — so this stores the minimal IDs needed and rebuilds a full
//  `ScanReport` by resolving those IDs against the static catalogs.
//

import Foundation
import SwiftData

// MARK: - Persisted Finding

/// A Codable, storage-friendly mirror of `Finding`.
struct PersistedFinding: Codable, Identifiable {
    var id: UUID
    var originalText: String
    var plainEnglish: String
    var categoryIDs: [String]
    var severityRaw: String
    var sourceRaw: String
    var chunkIndex: Int
    var whyItMatters: String?
    var questionToAsk: String?

    init(from finding: Finding) {
        self.id = finding.id
        self.originalText = finding.originalText
        self.plainEnglish = finding.plainEnglish
        self.categoryIDs = finding.categories.map(\.id)
        self.severityRaw = finding.severity.rawValue
        self.sourceRaw = finding.source == .aiJudged ? "aiJudged" : "guardrailRefused"
        self.chunkIndex = finding.chunkIndex
        self.whyItMatters = finding.whyItMatters
        self.questionToAsk = finding.questionToAsk
    }

    /// Rebuilds a display-ready `Finding`, resolving category IDs
    /// against the static `FeeCategory` catalog. Returns nil only if the
    /// severity string got corrupted somehow.
    func makeFinding() -> Finding? {
        guard let severity = SeverityLevel(rawValue: severityRaw) else { return nil }
        let categories = categoryIDs.compactMap { FeeCategory.byID[$0] }
        let source: Finding.FlagSource = sourceRaw == "guardrailRefused" ? .guardrailRefused : .aiJudged

        var finding = Finding(
            originalText: originalText,
            plainEnglish: plainEnglish,
            categories: categories,
            severity: severity,
            source: source,
            chunkIndex: chunkIndex
        )
        finding.whyItMatters = whyItMatters
        finding.questionToAsk = questionToAsk
        return finding
    }
}

// MARK: - FeeCategory lookup

extension FeeCategory {
    /// Every category referenced by any document type, keyed by id.
    /// Lets us reconstruct `FeeCategory` values from persisted string IDs
    /// without needing a separate master list to maintain.
    static let byID: [String: FeeCategory] = {
        var map: [String: FeeCategory] = [:]
        for docType in DocumentType.allTypes {
            for category in docType.categories {
                map[category.id] = category
            }
        }
        return map
    }()
}

// MARK: - SwiftData model

@Model
final class ScanHistoryEntry {
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var documentTypeID: String
    var findings: [PersistedFinding]

    /// Optional thumbnail of the first scanned page, shown in the history row.
    @Attribute(.externalStorage) var thumbnailData: Data?

    init(
        id: UUID = UUID(),
        createdAt: Date = .now,
        documentTypeID: String,
        findings: [PersistedFinding],
        thumbnailData: Data? = nil
    ) {
        self.id = id
        self.createdAt = createdAt
        self.documentTypeID = documentTypeID
        self.findings = findings
        self.thumbnailData = thumbnailData
    }

    /// Build a history entry directly from a freshly generated report.
    convenience init(report: ScanReport, thumbnailData: Data? = nil) {
        self.init(
            id: report.id,
            createdAt: report.createdAt,
            documentTypeID: report.documentType.id,
            findings: report.findings.map(PersistedFinding.init),
            thumbnailData: thumbnailData
        )
    }

    /// Rebuilds a full `ScanReport` for display. Returns nil if the
    /// document type no longer exists (e.g. removed in an app update).
    func makeReport() -> ScanReport? {
        guard let documentType = DocumentType.allTypes.first(where: { $0.id == documentTypeID }) else {
            return nil
        }
        let rebuiltFindings = findings.compactMap { $0.makeFinding() }
        return ScanReport(
            createdAt: createdAt,
            documentType: documentType,
            findings: rebuiltFindings
        )
    }

    var severityCounts: [SeverityLevel: Int] {
        var counts: [SeverityLevel: Int] = [:]
        for finding in findings {
            if let severity = SeverityLevel(rawValue: finding.severityRaw) {
                counts[severity, default: 0] += 1
            }
        }
        return counts
    }

    var highestSeverity: SeverityLevel {
        findings.compactMap { SeverityLevel(rawValue: $0.severityRaw) }.max() ?? .low
    }
}
