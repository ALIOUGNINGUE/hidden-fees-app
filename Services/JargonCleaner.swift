//
//  JargonCleaner.swift
//  Hidden Fee App
//
//  Created by Everyone Can Code Chicago on 7/14/26.
//

import SwiftUI
struct JargonCleaner {
    
    private static let replacements: [(String, String)] = [
        ("Annual Percentage Rate", "interest rate"),
        ("Penalty APR", "penalty rate"),
        ("APR", "rate"),
        ("creditworthiness", "credit score"),
        ("billing cycle", "billing period"),
        ("Cardmember Agreement", "contract"),
    ]
    
    static func clean(_ text: String) -> String {
        var result = text
        for (jargon, plain) in replacements {
            result = result.replacingOccurrences(
                of: jargon,
                with: plain,
                options: .caseInsensitive
            )
        }
        return result
    }
}
