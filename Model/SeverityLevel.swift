//
//  SeverityLevel.swift
//  Hidden Fee App
//
//  Created by Everyone Can Code Chicago on 7/15/26.
//

import SwiftUI
import SwiftUI

enum SeverityLevel: String, Comparable {
    case low
    case medium
    case high
    
    private var rank: Int {
        switch self {
        case .low:    return 0
        case .medium: return 1
        case .high:   return 2
        }
    }
    
    static func < (lhs: SeverityLevel, rhs: SeverityLevel) -> Bool {
        lhs.rank < rhs.rank
    }
    
    var label: String {
        switch self {
        case .high:   return "High — review carefully"
        case .medium: return "Medium — worth checking"
        case .low:    return "Low — minor"
        }
    }
    
    var color: Color {
        switch self {
        case .high:   return .red
        case .medium: return .orange
        case .low:    return .yellow
        }
    }
    
    static func calculate(from categories: [FeeCategory]) -> SeverityLevel {
        guard !categories.isEmpty else { return .low }
        
        let maxEscape = categories.map(\.escapeDifficulty).max() ?? 1
        let maxImpact = categories.map(\.impact).max() ?? 1
        let total = maxEscape + maxImpact
        
        switch total {
        case 5...6: return .high
        case 4:     return .medium
        default:    return .low
        }
    }
}
