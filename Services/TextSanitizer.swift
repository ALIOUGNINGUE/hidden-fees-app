//
//  TextSanitizer.swift
//  Hidden Fee App
//
//  Created by Everyone Can Code Chicago on 7/13/26.
//
import Foundation
struct TextSanitizer {
    
    private static let replacements: [(String, String)] = [
        ("annual percentage rate", "annual rate"),
        ("balance transfer", "account move"),
        ("cash advance", "early withdrawal"),
        ("credit card", "account"),
        ("prime rate", "base rate"),
        ("finance charge", "added amount"),
        ("minimum payment", "minimum required"),
        ("due date", "deadline"),
        ("membership fee", "membership requirement"),
        ("annual fee", "yearly requirement"),
        ("late fee", "late addition"),
        ("penalty apr", "consequence rate"),
        ("overdraft", "shortfall"),
        ("insufficient funds", "not enough funds"),
        ("creditworthiness", "eligibility"),
        ("billing cycle", "billing period"),
        ("apr", "rate"),
        ("interest", "additional amounts"),
        ("balance", "remaining amount"),
        ("transfer", "move"),
        ("loan", "agreement"),
        ("transaction", "activity"),
        ("cash", "funds"),
        ("fee", "surcharge"),
        ("payment", "submission"),
        ("penalty", "consequence"),
        ("charge", "addition"),
        ("debt", "obligation"),
        ("refund", "return"),
        ("delinquent", "overdue"),
        ("cost", "requirement"),
        ("paid in full", "completely fulfilled"),
        ("pay in full", "completely fulfill"),
        ("promotional period", "introductory period"),
        ("promotional rate", "starting rate"),
        ("promotional", "introductory"),
        ("assessed", "applied"),
        ("account opening", "enrollment"),
        ("account", "plan"),
    ]
    
    static func sanitize(_ text: String) -> String {
        var result = text.lowercased()
        
        for (original, replacement) in replacements {
            result = result.replacingOccurrences(of: original, with: replacement)
        }
        
        result = result.replacingOccurrences(
            of: #"\$(\d[\d,]*(\.\d+)?)"#,
            with: "$1 dolars",
            options: .regularExpression
        )
        result = result.replacingOccurrences(
            of: #"(\d+(\.\d+)?)\s*%"#,
            with: "$1 percent",
            options: .regularExpression
        )
        
        return result
    }
}
