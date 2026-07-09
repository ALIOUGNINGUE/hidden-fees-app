//
//  DocumentType.swift
//  FeeFinder
//
//  Created by Everyone Can Code Chicago on 7/1/26.
//

import SwiftUI
 
struct DocumentType: Identifiable, Hashable {
    let id: String
    let name: String
    let subtitle: String
    let iconName: String
    let accentColor: Color
    let flagLabels: [FlagLabel]
 
    struct FlagLabel: Identifiable, Hashable {
        let id = UUID()
        let text: String
        let dotColor: Color
    }
}
 
extension DocumentType {
 
    static let creditCard = DocumentType(
        id: "credit_card",
        name: "Credit Card",
        subtitle: "APR disclosures, penalty rates, cash advance fees",
        iconName: "creditcard.fill",
        accentColor: Color(red: 0.85, green: 0.65, blue: 0.13),
        flagLabels: [
            .init(text: "Late Fee",       dotColor: .red),
            .init(text: "Penalty",        dotColor: .orange),
            .init(text: "Rate Increase",  dotColor: .yellow),
            .init(text: "Auto-Renewal",   dotColor: .blue),
            .init(text: "Cancellation",   dotColor: .purple),
        ]
    )
 
    static let apartmentLease = DocumentType(
        id: "apartment_lease",
        name: "Apartment Lease",
        subtitle: "Late fees, lease breaks, renewal terms",
        iconName: "house.fill",
        accentColor: .green,
        flagLabels: [
            .init(text: "Late Fee",           dotColor: .red),
            .init(text: "Early Termination",  dotColor: .orange),
            .init(text: "Service Fee",        dotColor: .yellow),
            .init(text: "Auto-Renewal",       dotColor: .blue),
            .init(text: "Penalty",            dotColor: .purple),
        ]
    )
 
    static let cellContract = DocumentType(
        id: "cell_contract",
        name: "Cell Contract",
        subtitle: "ETFs, price lock terms, data throttling clauses",
        iconName: "iphone.gen2",
        accentColor: Color(red: 0.55, green: 0.55, blue: 1.0),
        flagLabels: [
            .init(text: "Early Termination",  dotColor: .red),
            .init(text: "Rate Change",        dotColor: .orange),
            .init(text: "Auto-Renewal",       dotColor: .blue),
            .init(text: "Service Fee",        dotColor: .yellow),
        ]
    )
 
    static let bnplAgreement = DocumentType(
        id: "bnpl",
        name: "BNPL Agreement",
        subtitle: "Deferred interest, missed payment penalties",
        iconName: "cart.fill",
        accentColor: Color(red: 1.0, green: 0.45, blue: 0.55),
        flagLabels: [
            .init(text: "Deferred Interest",  dotColor: .red),
            .init(text: "Late Fee",           dotColor: .orange),
            .init(text: "Penalty",            dotColor: .yellow),
            .init(text: "Minimum Payment",    dotColor: .blue),
        ]
    )
 
    static let studentLoan = DocumentType(
        id: "student_loan",
        name: "Student Loan",
        subtitle: "Capitalized interest, forbearance limits, servicer transfer rights",
        iconName: "graduationcap.fill",
        accentColor: Color(red: 0.85, green: 0.65, blue: 0.13),  // gold
        flagLabels: [
            .init(text: "Interest",       dotColor: .red),
            .init(text: "Rate Change",    dotColor: .orange),
            .init(text: "Service Fee",    dotColor: .yellow),
            .init(text: "Default",        dotColor: .purple),
        ]
    )
    static let allTypes: [DocumentType] = [
        .creditCard, .apartmentLease, .cellContract, .bnplAgreement, .studentLoan
    ]
}
