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
    let categories: [FeeCategory]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: DocumentType, rhs: DocumentType) -> Bool {
        lhs.id == rhs.id
    }
}
extension DocumentType {
    
    static let creditCard = DocumentType(
        id: "credit_card",
        name: "Credit Card",
        subtitle: "APR disclosures, penalty rates, cash advance fees",
        iconName: "creditcard.fill",
        accentColor: Color(red: 0.85, green: 0.65, blue: 0.13),
        categories: [
            .penaltyRate, .deferredInterest, .cashAdvanceFee,
            .balanceTransferFee, .lateFee, .minimumPaymentTrap,
            .autoRenewal, .earlyTerminationOrCancellation,
            .foreignTransactionFee, .overageOrOverLimit,
            .termsChangeClause, .universalDefault, .junkFee
        ]
    )
    
    static let apartmentLease = DocumentType(
        id: "apartment_lease",
        name: "Apartment Lease",
        subtitle: "Late fees, lease breaks, renewal terms",
        iconName: "house.fill",
        accentColor: .green,
        categories: [
            .lateFee, .earlyTerminationOrCancellation, .autoRenewal,
            .rentIncrease, .petFee, .moveOutCharge,
            .utilityResponsibility, .guestRestrictionPenalty,
            .holdoverClause, .rightOfEntry,
            .soleDiscretionClause, .junkFee
        ]
    )
    
    static let cellContract = DocumentType(
        id: "cell_contract",
        name: "Cell Contract",
        subtitle: "ETFs, price lock terms, data throttling clauses",
        iconName: "iphone.gen2",
        accentColor: Color(red: 0.55, green: 0.55, blue: 1.0),
        categories: [
            .earlyTerminationOrCancellation, .devicePaymentAcceleration,
            .dataThrottling, .priceLockTerms, .autoRenewal,
            .rateChange, .planChangeRestriction,
            .overageOrOverLimit, .junkFee
        ]
    )
    
    static let bnplAgreement = DocumentType(
        id: "bnpl",
        name: "BNPL Agreement",
        subtitle: "Deferred interest, missed payment penalties",
        iconName: "cart.fill",
        accentColor: Color(red: 1.0, green: 0.45, blue: 0.55),
        categories: [
            .deferredInterest, .lateFee,
            .automaticPaymentEnrollment, .creditReporting,
            .merchantReturnConflict, .minimumPaymentTrap, .junkFee
        ]
    )
    
    static let studentLoan = DocumentType(
        id: "student_loan",
        name: "Student Loan",
        subtitle: "Capitalized interest, forbearance limits, servicer transfer rights",
        iconName: "graduationcap.fill",
        accentColor: Color(red: 0.85, green: 0.65, blue: 0.13),
        categories: [
            .capitalizedInterest, .rateChange, .prepaymentPenalty,
            .lateFee, .defaultOrAcceleration,
            .forbearanceLimits, .servicerTransfer, .coSignerRelease,
            .junkFee
        ]
    )
    
    static let allTypes: [DocumentType] = [
        .creditCard, .apartmentLease, .cellContract,
        .bnplAgreement, .studentLoan
    ]
}
