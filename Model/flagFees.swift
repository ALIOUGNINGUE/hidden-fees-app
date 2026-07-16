//
//  flagFees.swift
//  Hidden Fee App
//
//  Created by Everyone Can Code Chicago on 7/13/26.
//
import SwiftUI
struct FlaggedFee: Identifiable {
    let id = UUID()
    let originalText: String
    let plainText: String?
    let chunkIndex: Int
    let source: FlagSource
    
    enum FlagSource {
        case aiJudged
        case guardrailRefused
    }
}
