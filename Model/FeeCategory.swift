//
//  FeeCatagory.swift
//  Hidden Fee App
//
//  Created by Everyone Can Code Chicago on 7/14/26.
//

import SwiftUI
struct FeeCategory: Identifiable, Hashable {
    let id: String
    let displayName: String
    let definition: String
    let keywords: [(word: String, weight: Int)]
    let threshold: Int
    let escapeDifficulty: Int  // 1-3
    let impact: Int            // 1-3
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: FeeCategory, rhs: FeeCategory) -> Bool {
        lhs.id == rhs.id
    }
}
extension FeeCategory {
    
    // MARK: - Interest & Rates
    
    static let penaltyRate = FeeCategory(
        id: "penalty_rate",
        displayName: "Penalty Rate",
        definition: "A higher interest rate applied to your account as punishment for breaking a rule, like missing a payment. Once triggered, it may never go back down.",
        keywords: [
            ("penalty rate", 6),
            ("penalty apr", 6),
            ("penalty", 5),
            ("punish", 5),
            ("indefinitely", 4),
            ("forever", 4),
            ("higher rate", 3),
            ("higher interest", 3),
            ("rate increase", 2),
            ("apr", 1),
            ("rate", 1),
        ],
        threshold: 6,
        escapeDifficulty: 3,
        impact: 3
    )
    
    static let deferredInterest = FeeCategory(
        id: "deferred_interest",
        displayName: "Deferred Interest",
        definition: "Interest that builds up silently during a promotional period. If you don't pay the full balance before the period ends, you owe all the accumulated interest going back to the original purchase date.",
        keywords: [
            ("deferred", 6),
            ("retroactive", 6),
            ("promotional period", 5),
            ("original transaction date", 5),
            ("original purchase date", 5),
            ("original date", 4),
            ("back to day one", 4),
            ("promotional", 3),
            ("accumulate", 3),
            ("accrued", 3),
            ("paid in full", 2),
            ("pay the full amount", 2),
            ("interest", 1),
        ],
        threshold: 6,
        escapeDifficulty: 2,
        impact: 3

    )
    
    static let capitalizedInterest = FeeCategory(
        id: "capitalized_interest",
        displayName: "Capitalized Interest",
        definition: "Unpaid interest that gets added to your loan balance, so you start paying interest on top of interest. Your debt grows even if you're making payments.",
        keywords: [
            ("capitalized", 6),
            ("capitalize", 6),
            ("interest on interest", 6),
            ("added to your balance", 5),
            ("added to the balance", 5),
            ("interest added to", 5),
            ("unpaid interest", 4),
            ("grows", 2),
            ("principal", 2),
            ("balance", 1),
        ],
        threshold: 6,
        escapeDifficulty: 3,
        impact: 3
    )
    
    static let rateChange = FeeCategory(
        id: "rate_change",
        displayName: "Rate Change",
        definition: "A clause that allows the company to increase your interest rate or fees, sometimes without warning and sometimes based on vague conditions like 'market factors.'",
        keywords: [
            ("rate may change", 6),
            ("rate can change", 6),
            ("rate could change", 6),
            ("subject to change", 5),
            ("variable rate", 5),
            ("rate will vary", 5),
            ("market conditions", 4),
            ("market factors", 4),
            ("adjust the rate", 4),
            ("change your rate", 4),
            ("modify the rate", 4),
            ("introductory rate", 3),
            ("variable", 3),
            ("fluctuate", 3),
        ],
        threshold: 5,
        escapeDifficulty: 2,
        impact: 2
    )
    
    static let universalDefault = FeeCategory(
        id: "universal_default",
        displayName: "Universal Default",
        definition: "A clause that lets this company raise your rate because you were late on a payment to a completely different company. Your credit card rate goes up because you paid your phone bill late.",
        keywords: [
            ("universal default", 7),
            ("cross-default", 7),
            ("other account", 5),
            ("other creditor", 5),
            ("another company", 5),
            ("different account", 5),
            ("other lender", 5),
            ("another lender", 5),
            ("other obligation", 4),
        ],
        threshold: 5,
        escapeDifficulty: 3,
        impact: 3

    )
    
    static let minimumPaymentTrap = FeeCategory(
        id: "minimum_payment_trap",
        displayName: "Minimum Payment Trap",
        definition: "Paying only the minimum keeps you in good standing but barely touches the actual debt. A $5,000 balance at 24% with minimum payments could take over 20 years to pay off.",
        keywords: [
            ("minimum payment", 6),
            ("minimum amount due", 6),
            ("minimum required", 5),
            ("minimum bill", 5),
            ("minimum due", 5),
            ("pay only the minimum", 5),
            ("minimum", 3),
        ],
        threshold: 5,
        escapeDifficulty: 1,
        impact: 3

    )
    
    // MARK: - Fees & Charges
    
    static let lateFee = FeeCategory(
        id: "late_fee",
        displayName: "Late Fee",
        definition: "An extra charge for not paying by the deadline. Late fees can compound — generating their own interest — or stack, where one missed payment triggers multiple separate fees at once.",
        keywords: [
            ("late fee", 6),
            ("late charge", 6),
            ("late payment", 5),
            ("past due", 5),
            ("missed payment", 5),
            ("pay late", 5),
            ("paid late", 5),
            ("delinquent", 5),
            ("overdue", 4),
            ("not received by", 3),
            ("after the due date", 3),
            ("late", 2),
        ],
        threshold: 5,
        escapeDifficulty: 1,
        impact: 3

    )
    
    static let cashAdvanceFee = FeeCategory(
        id: "cash_advance_fee",
        displayName: "Cash Advance Fee",
        definition: "A fee charged when you use your credit card to get cash. Unlike purchases, interest usually starts immediately with no grace period, and the rate is often higher.",
        keywords: [
            ("cash advance", 7),
            ("cash withdrawal", 7),
            ("withdraw cash", 6),
            ("atm withdrawal", 6),
            ("atm", 4),
            ("cash", 2),
        ],
        threshold: 6,
        escapeDifficulty: 1,
        impact: 3

    )
    
    static let balanceTransferFee = FeeCategory(
        id: "balance_transfer_fee",
        displayName: "Balance Transfer Fee",
        definition: "A fee for moving a balance from one account to another, usually 3-5% of the amount transferred. A $5,000 transfer could cost $150-250 just to move.",
        keywords: [
            ("balance transfer", 7),
            ("transfer fee", 6),
            ("transfer a balance", 6),
            ("move a balance", 5),
            ("moving money between", 5),
            ("transfer", 2),
        ],
        threshold: 6,
        escapeDifficulty: 1,
        impact: 2

    )
    
    static let foreignTransactionFee = FeeCategory(
        id: "foreign_transaction_fee",
        displayName: "Foreign Transaction Fee",
        definition: "A percentage added to every purchase made outside your home country or in a foreign currency, typically 1-3% on top of the purchase price.",
        keywords: [
            ("foreign transaction", 7),
            ("foreign purchase", 6),
            ("international transaction", 6),
            ("foreign currency", 6),
            ("outside the country", 5),
            ("overseas", 4),
            ("abroad", 4),
            ("foreign", 3),
        ],
        threshold: 5,
        escapeDifficulty: 1,
        impact: 1

    )
    
    static let prepaymentPenalty = FeeCategory(
        id: "prepayment_penalty",
        displayName: "Prepayment Penalty",
        definition: "A fee for paying off your loan early. You're punished for getting out of debt faster, because the lender loses the interest they expected to collect.",
        keywords: [
            ("prepayment penalty", 7),
            ("prepayment", 6),
            ("pay off early", 6),
            ("early payoff", 6),
            ("paying early", 5),
            ("paid off early", 5),
            ("early repayment", 5),
            ("pay ahead", 4),
        ],
        threshold: 6,
        escapeDifficulty: 2,
        impact: 2
    )
    
    static let petFee = FeeCategory(
        id: "pet_fee",
        displayName: "Pet Fee",
        definition: "An additional charge for having a pet in your rental, which may include a one-time deposit, monthly pet rent, or both. Weight and breed restrictions may apply with separate fees.",
        keywords: [
            ("pet fee", 7),
            ("pet deposit", 7),
            ("pet rent", 7),
            ("animal fee", 6),
            ("dog fee", 6),
            ("cat fee", 6),
            ("pet surcharge", 6),
            ("pet", 4),
            ("animal", 3),
            ("breed", 3),
        ],
        threshold: 5,
        escapeDifficulty: 1,
        impact: 2

    )
    
    static let moveOutCharge = FeeCategory(
        id: "move_out_charge",
        displayName: "Move-Out Charge",
        definition: "Fees deducted from your security deposit or billed separately when you leave, covering cleaning, painting, carpet replacement, or other costs that may go beyond normal wear and tear.",
        keywords: [
            ("move out", 6),
            ("move-out", 6),
            ("cleaning fee", 6),
            ("carpet replacement", 6),
            ("security deposit", 5),
            ("wear and tear", 5),
            ("restoration", 4),
            ("repaint", 4),
            ("deducted from your deposit", 5),
        ],
        threshold: 5,
        escapeDifficulty: 2,
        impact: 1

    )
    
    static let junkFee = FeeCategory(
        id: "junk_fee",
        displayName: "Junk Fee",
        definition: "A vague or unnecessary charge that pads the bill beyond the advertised price. Includes service fees, administrative fees, processing fees, regulatory recovery fees, origination fees, convenience fees, and amenity charges. Often named to sound official or mandatory when they're just extra profit.",
        keywords: [
            ("service fee", 5),
            ("processing fee", 5),
            ("administrative fee", 5),
            ("convenience fee", 5),
            ("maintenance fee", 5),
            ("regulatory fee", 5),
            ("recovery fee", 5),
            ("origination fee", 5),
            ("amenity fee", 5),
            ("application fee", 5),
            ("setup fee", 5),
            ("activation fee", 5),
            ("documentation fee", 5),
            ("technology fee", 5),
            ("fee", 1),
        ],
        threshold: 5,
        escapeDifficulty: 1,
        impact: 1
    )
    
    static let overageOrOverLimit = FeeCategory(
        id: "overage_over_limit",
        displayName: "Overage or Over-Limit Fee",
        definition: "Extra charges that kick in when you exceed a limit — your credit limit, data cap, or usage threshold. Often applies even on plans marketed as 'unlimited,' where the limit is hidden in fine print.",
        keywords: [
            ("over limit", 6),
            ("over-limit", 6),
            ("overage", 6),
            ("exceed your limit", 6),
            ("exceeded the limit", 6),
            ("over the limit", 5),
            ("usage threshold", 5),
            ("unlimited", 3),
            ("exceed", 2),
        ],
        threshold: 6,
        escapeDifficulty: 1,
        impact: 2

    )
    
    // MARK: - Contract Terms
    
    static let earlyTerminationOrCancellation = FeeCategory(
        id: "early_termination_cancellation",
        displayName: "Early Termination / Cancellation",
        definition: "A fee for ending or canceling your agreement. Can range from a flat charge to the remaining balance of all payments you would have made. Some companies charge for canceling even after the contract period ends.",
        keywords: [
            ("early termination", 7),
            ("termination fee", 7),
            ("cancellation fee", 7),
            ("cancel fee", 6),
            ("break the lease", 6),
            ("lease break", 6),
            ("end your contract", 5),
            ("cancel early", 5),
            ("ending early", 5),
            ("cancel your", 3),
            ("terminate", 3),
            ("cancellation", 3),
        ],
        threshold: 5,
        escapeDifficulty: 2,
        impact: 2

    )
    
    static let autoRenewal = FeeCategory(
        id: "auto_renewal",
        displayName: "Auto-Renewal",
        definition: "The contract automatically continues and charges you for another term unless you cancel within a specific window. The cancellation window is often short and easy to miss.",
        keywords: [
            ("auto-renew", 7),
            ("auto renew", 7),
            ("automatically renew", 7),
            ("automatic renewal", 7),
            ("renews automatically", 6),
            ("renewed automatically", 6),
            ("renewal term", 5),
            ("cancellation window", 5),
            ("unless you cancel", 4),
            ("renew", 2),
        ],
        threshold: 6,
        escapeDifficulty: 2,
        impact: 2

    )
    
    static let termsChangeClause = FeeCategory(
        id: "terms_change_clause",
        displayName: "Terms Change Clause",
        definition: "A clause giving the company the right to change any part of your agreement — rates, fees, rules — at any time, often with minimal notice. You agreed to terms that can become different terms.",
        keywords: [
            ("change the terms", 6),
            ("change your terms", 6),
            ("modify the terms", 6),
            ("right to change", 6),
            ("terms may change", 6),
            ("amend the agreement", 5),
            ("update the terms", 5),
            ("revise the terms", 5),
            ("at any time", 3),
            ("without notice", 4),
            ("terms", 1),
        ],
        threshold: 6,
        escapeDifficulty: 3,
        impact: 1
    )
    
    static let rentIncrease = FeeCategory(
        id: "rent_increase",
        displayName: "Rent Increase",
        definition: "A clause allowing the landlord to raise your rent, sometimes with vague conditions or short notice. The amount and frequency of increases may not be clearly limited.",
        keywords: [
            ("rent increase", 7),
            ("raise the rent", 7),
            ("raise your rent", 7),
            ("increase rent", 6),
            ("higher rent", 5),
            ("rent adjustment", 5),
            ("rent may increase", 5),
            ("rent", 2),
        ],
        threshold: 6,
        escapeDifficulty: 2,
        impact: 2

    )
    
    static let holdoverClause = FeeCategory(
        id: "holdover_clause",
        displayName: "Holdover Clause",
        definition: "If you stay even one day past your lease end date, you may owe a full extra month of rent or double your normal rate. The penalty is extreme relative to the violation.",
        keywords: [
            ("holdover", 7),
            ("hold over", 7),
            ("stay past", 5),
            ("remain after", 5),
            ("after the lease ends", 5),
            ("past the lease", 5),
            ("double rent", 6),
            ("double the rent", 6),
            ("month-to-month", 4),
        ],
        threshold: 5,
        escapeDifficulty: 2,
        impact: 3
    )
    
    static let rightOfEntry = FeeCategory(
        id: "right_of_entry",
        displayName: "Right of Entry",
        definition: "A clause allowing the landlord to enter your unit, sometimes with vaguely defined notice requirements. 'Reasonable notice' can mean different things to different landlords.",
        keywords: [
            ("right of entry", 7),
            ("right to enter", 7),
            ("enter your unit", 6),
            ("enter the premises", 6),
            ("access your apartment", 6),
            ("reasonable notice", 5),
            ("landlord may enter", 6),
            ("enter without", 5),
            ("enter your", 3),
        ],
        threshold: 6,
        escapeDifficulty: 2,
        impact: 1
    )
    
    static let guestRestrictionPenalty = FeeCategory(
        id: "guest_restriction_penalty",
        displayName: "Guest Restriction Penalty",
        definition: "Rules limiting how long guests can stay or how often they can visit, with penalties if violated. Definitions of 'guest' versus 'occupant' are often vague.",
        keywords: [
            ("guest restriction", 7),
            ("guest policy", 6),
            ("overnight guest", 6),
            ("guest stay", 5),
            ("unauthorized occupant", 6),
            ("visitor policy", 5),
            ("visitor restriction", 5),
            ("occupant", 4),
            ("guest", 3),
        ],
        threshold: 6,
        escapeDifficulty: 1,
        impact: 1
    )
    
    static let soleDiscretionClause = FeeCategory(
        id: "sole_discretion_clause",
        displayName: "Sole Discretion Clause",
        definition: "Language giving one party the power to make decisions 'at their sole discretion,' meaning they can interpret the rules however they want with no obligation to be fair or consistent.",
        keywords: [
            ("sole discretion", 7),
            ("at our discretion", 7),
            ("at its discretion", 7),
            ("in our judgment", 6),
            ("as we see fit", 6),
            ("we determine", 5),
            ("we decide", 4),
            ("without explanation", 5),
            ("discretion", 4),
        ],
        threshold: 6,
        escapeDifficulty: 3,
        impact: 1
    )
    
    static let utilityResponsibility = FeeCategory(
        id: "utility_responsibility",
        displayName: "Utility Responsibility",
        definition: "Unclear language about which utilities you pay versus what's included in rent. Water, trash, pest control, and internet may or may not be your responsibility.",
        keywords: [
            ("utility", 5),
            ("utilities", 5),
            ("water bill", 6),
            ("electric bill", 6),
            ("electricity", 4),
            ("trash removal", 5),
            ("pest control", 5),
            ("internet included", 5),
            ("responsible for utilities", 6),
            ("tenant pays", 4),
        ],
        threshold: 5,
        escapeDifficulty: 1,
        impact: 1
    )
    
    static let priceLockTerms = FeeCategory(
        id: "price_lock_terms",
        displayName: "Price Lock Terms",
        definition: "A promise that your price won't change, but with conditions that let the company change it anyway. The 'lock' often has exceptions that make it meaningless.",
        keywords: [
            ("price lock", 7),
            ("locked rate", 6),
            ("locked price", 6),
            ("guaranteed rate", 6),
            ("price guarantee", 6),
            ("rate lock", 6),
            ("price won't change", 5),
            ("price will not change", 5),
            ("fixed price", 4),
            ("lock", 2),
        ],
        threshold: 6,
        escapeDifficulty: 2,
        impact: 2
    )
    
    static let dataThrottling = FeeCategory(
        id: "data_throttling",
        displayName: "Data Throttling",
        definition: "Your internet speed is intentionally slowed after you hit a usage threshold, even on plans marketed as 'unlimited.' The threshold and speed reduction are often buried in fine print.",
        keywords: [
            ("throttle", 7),
            ("throttling", 7),
            ("reduced speed", 6),
            ("slower speed", 6),
            ("speed reduction", 6),
            ("deprioritize", 6),
            ("deprioritized", 6),
            ("data cap", 5),
            ("speed cap", 5),
            ("slow down", 3),
            ("bandwidth", 3),
        ],
        threshold: 6,
        escapeDifficulty: 1,
        impact: 1
    )
    
    static let devicePaymentAcceleration = FeeCategory(
        id: "device_payment_acceleration",
        displayName: "Device Payment Acceleration",
        definition: "If you cancel your phone service, the entire remaining balance on your device payment plan becomes due immediately instead of continuing monthly payments.",
        keywords: [
            ("device payment", 7),
            ("device balance", 7),
            ("phone balance", 6),
            ("equipment balance", 6),
            ("phone payment", 6),
            ("device installment", 6),
            ("remaining balance on your device", 7),
            ("entire balance due", 5),
            ("device", 2),
        ],
        threshold: 6,
        escapeDifficulty: 3,
        impact: 3
    )
    
    static let planChangeRestriction = FeeCategory(
        id: "plan_change_restriction",
        displayName: "Plan Change Restriction",
        definition: "Upgrading your plan is easy, but downgrading has a waiting period, fee, or restriction. You can always pay more but getting back to less is deliberately difficult.",
        keywords: [
            ("downgrade", 6),
            ("change your plan", 5),
            ("switch plans", 5),
            ("plan change", 5),
            ("lower your plan", 5),
            ("reduce your plan", 5),
            ("upgrade", 3),
            ("plan", 1),
        ],
        threshold: 6,
        escapeDifficulty: 1,
        impact: 2
    )
    
    static let defaultOrAcceleration = FeeCategory(
        id: "default_acceleration",
        displayName: "Default / Acceleration",
        definition: "What counts as breaking your agreement and what happens when you do. Often one missed payment triggers the entire remaining balance to become due immediately, turning a small mistake into a massive demand.",
        keywords: [
            ("event of default", 7),
            ("declare default", 7),
            ("in default", 6),
            ("acceleration", 6),
            ("entire balance due", 6),
            ("full balance due", 6),
            ("immediately due", 5),
            ("default", 4),
            ("accelerate", 4),
        ],
        threshold: 6,
        escapeDifficulty: 3,
        impact: 3
    )
    
    static let forbearanceLimits = FeeCategory(
        id: "forbearance_limits",
        displayName: "Forbearance Limits",
        definition: "Restrictions on how long you can pause or reduce payments during financial hardship. Interest often continues accumulating during forbearance, increasing what you owe.",
        keywords: [
            ("forbearance", 7),
            ("hardship", 5),
            ("pause payments", 6),
            ("defer payments", 5),
            ("payment pause", 5),
            ("financial hardship", 6),
            ("temporary relief", 5),
            ("deferment", 5),
        ],
        threshold: 6,
        escapeDifficulty: 2,
        impact: 2
    )
    
    static let servicerTransfer = FeeCategory(
        id: "servicer_transfer",
        displayName: "Servicer Transfer",
        definition: "Your loan can be sold or transferred to a different company without your consent. The new servicer may have different processes, payment portals, and customer service quality.",
        keywords: [
            ("servicer transfer", 7),
            ("transfer your loan", 6),
            ("loan sold", 6),
            ("loan transferred", 6),
            ("assign the loan", 6),
            ("new servicer", 6),
            ("sold to another", 5),
            ("servicer", 4),
        ],
        threshold: 6,
        escapeDifficulty: 3,
        impact: 1
    )
    
    static let coSignerRelease = FeeCategory(
        id: "co_signer_release",
        displayName: "Co-Signer Release",
        definition: "The conditions for removing a co-signer from the loan are often nearly impossible to meet — requiring a credit score, income level, and payment history that few borrowers can achieve.",
        keywords: [
            ("co-signer", 7),
            ("cosigner", 7),
            ("co signer", 7),
            ("co-signer release", 7),
            ("remove the co-signer", 7),
            ("release the co-signer", 7),
            ("guarantor", 5),
        ],
        threshold: 6,
        escapeDifficulty: 3,
        impact: 1
    )
    
    static let automaticPaymentEnrollment = FeeCategory(
        id: "automatic_payment_enrollment",
        displayName: "Automatic Payment Enrollment",
        definition: "You're signed up for automatic charges without clearly agreeing to it. Canceling the automatic payment may require separate steps from canceling the service itself.",
        keywords: [
            ("automatic payment", 7),
            ("auto-pay", 7),
            ("autopay", 7),
            ("automatically charge", 6),
            ("automatically deduct", 6),
            ("recurring payment", 5),
            ("enrolled in automatic", 6),
            ("recurring charge", 5),
            ("recurring", 3),
        ],
        threshold: 6,
        escapeDifficulty: 1,
        impact: 2
    )
    
    static let creditReporting = FeeCategory(
        id: "credit_reporting",
        displayName: "Credit Reporting",
        definition: "The company reports your payment activity to credit bureaus, which wasn't clearly disclosed. A missed payment on a small buy-now-pay-later purchase can damage your credit score.",
        keywords: [
            ("credit report", 7),
            ("credit bureau", 7),
            ("credit score", 6),
            ("credit history", 6),
            ("report to", 3),
            ("reported to", 4),
            ("credit agency", 5),
            ("credit", 2),
        ],
        threshold: 6,
        escapeDifficulty: 2,
        impact: 2

    )
    
    static let merchantReturnConflict = FeeCategory(
        id: "merchant_return_conflict",
        displayName: "Merchant Return Conflict",
        definition: "You returned the item to the store, but the payment plan company still expects payment. The refund process between the merchant and the lender isn't your problem — except it is.",
        keywords: [
            ("return the item", 6),
            ("returned the item", 6),
            ("merchant return", 6),
            ("refund", 4),
            ("return policy", 5),
            ("returned merchandise", 6),
            ("store return", 5),
            ("return", 2),
        ],
        threshold: 6,
        escapeDifficulty: 2,
        impact: 1

    )
}
