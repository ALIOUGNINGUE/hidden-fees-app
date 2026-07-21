//
//  ScanReport.swift
//  Hidden Fee App
//
//  Created by Everyone Can Code Chicago on 7/15/26.
//

import SwiftUI
import Foundation

@Observable
final class ScanHistory {
    var reports: [ScanReport] = []

    func add(_ report: ScanReport) {
        reports.insert(report, at: 0)
    }
}

struct Finding: Identifiable {
    let id = UUID()
    let originalText: String
    let plainEnglish: String
    let categories: [FeeCategory]
    let severity: SeverityLevel
    let source: FlagSource
    let chunkIndex: Int
    let contextBefore: [String]
    let contextAfter: [String]

    enum FlagSource {
        case aiJudged
        case guardrailRefused
    }
}

struct ScanReport: Identifiable {
    let id = UUID()
    let createdAt: Date
    let documentType: DocumentType
    let findings: [Finding]
    
    init(
        createdAt: Date = Date(),
        documentType: DocumentType,
        findings: [Finding]
    ) {
        self.createdAt = createdAt
        self.documentType = documentType
        self.findings = findings
    }
    
    var sortedFindings: [Finding] {
        findings.sorted { $0.severity > $1.severity }
    }
    
    var severityCounts: [SeverityLevel: Int] {
        var counts: [SeverityLevel: Int] = [:]
        for finding in findings {
            counts[finding.severity, default: 0] += 1
        }
        return counts
    }
    
    var totalFindings: Int {
        findings.count
    }
    
    var summaryLine: String {
        if findings.isEmpty {
            return "No hidden fee terms found. Still review the full document carefully."
        }
        
        let high = severityCounts[.high] ?? 0
        let medium = severityCounts[.medium] ?? 0
        let low = severityCounts[.low] ?? 0
        
        var parts: [String] = []
        if high > 0 { parts.append("\(high) high risk") }
        if medium > 0 { parts.append("\(medium) medium risk") }
        if low > 0 { parts.append("\(low) low risk") }
        
        return "Found \(findings.count) hidden fee term\(findings.count == 1 ? "" : "s"): \(parts.joined(separator: ", "))."
    }
    
    var allCategories: [FeeCategory] {
        var seen = Set<String>()
        var result: [FeeCategory] = []
        for finding in findings {
            for category in finding.categories {
                if !seen.contains(category.id) {
                    seen.insert(category.id)
                    result.append(category)
                }
            }
        }
        return result
    }
}
