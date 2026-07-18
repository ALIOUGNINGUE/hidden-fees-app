//
//  DocumentChunker.swift
//  Hidden Fee App
//
//  Created by Everyone Can Code Chicago on 7/9/26.
//
import SwiftUI
struct HeadingDetector {
    
    /// Returns true if this fragment is a heading with no content of its own.
    static func isHeading(_ text: String) -> Bool {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Long text is never a heading
        let wordCount = trimmed.split(separator: " ").count
        if wordCount > 8 { return false }
        
        // Contains a number, dollar sign, or percentage → has content
        if trimmed.range(of: #"[\d$%]"#, options: .regularExpression) != nil {
            return false
        }
        
        // Contains a colon with content after it → has content
        if let colonIndex = trimmed.firstIndex(of: ":") {
            let afterColon = trimmed[trimmed.index(after: colonIndex)...]
                .trimmingCharacters(in: .whitespaces)
            if !afterColon.isEmpty { return false }
        }
        
        // Says "none" or "n/a" → that's an answer, not a heading
        let lowered = trimmed.lowercased()
        if lowered.contains("none") || lowered.contains("n/a") {
            return false
        }
        
        // Contains a verb that indicates a clause
        let clauseVerbs = [
            " will ", " may ", " must ", " shall ", " can ",
            " is ", " are ", " was ", " were ", " have ", " has ",
            " do ", " does ", " apply ", " charged ", " pays "
        ]
        if clauseVerbs.contains(where: { lowered.contains($0) }) {
            return false
        }
        
        // Short, no numbers, no colon content, no verb → heading
        return true
    }
}
struct SentenceSplitter {
    
        static func normalizeNumbers(_ text: String) -> String {
        return text.replacingOccurrences(
            of: #"(\d)\s*\.\s*(\d)"#,
            with: "$1.$2",
            options: .regularExpression
        )
    }
    static func split(chunk: DocumentChunk) -> [String] {
        let cleaned = normalizeNumbers(chunk.text)
        
        if chunk.isTableContent {

            return cleaned
                .components(separatedBy: .newlines)
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
        } else {
            let joined = cleaned
                .components(separatedBy: .newlines)
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
                .joined(separator: " ")
            
            let pattern = #"(?<=[.?!])\s+(?=[A-Z])"#
            guard let regex = try? NSRegularExpression(
                pattern: pattern,
                options: []
            ) else {
                return [joined]
            }
            
            let nsString = joined as NSString
            var results: [String] = []
            var lastStart = 0
            
            let matches = regex.matches(
                in: joined,
                options: [],
                range: NSRange(location: 0, length: nsString.length)
            )
            
            for match in matches {
                let range = NSRange(location: lastStart, length: match.range.location - lastStart)
                let sentence = nsString.substring(with: range)
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                if !sentence.isEmpty {
                    results.append(sentence)
                }
                lastStart = match.range.location + match.range.length
            }
            
            let remaining = nsString.substring(from: lastStart)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            if !remaining.isEmpty {
                results.append(remaining)
            }
            
            return results
        }
    }
}
struct DocumentChunk {
    let text: String
    let isTableContent: Bool
    let originalIndex: Int
}

func chunkDocument(_ raw: String) -> [DocumentChunk] {
    let paragraphs = raw.components(separatedBy: "\n\n")
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        .filter { !$0.isEmpty }
    
    return paragraphs.enumerated().map { index, paragraph in
        let lines = paragraph.components(separatedBy: .newlines)
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        let shortLines = lines.filter { $0.split(separator: " ").count < 10 }
        let isTable = lines.count > 1 && shortLines.count > lines.count / 2
        
        return DocumentChunk(
            text: paragraph,
            isTableContent: isTable,
            originalIndex: index
        )
    }
}
