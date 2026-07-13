struct OCRStub {
    
    static func fakeCreditCardChunks() -> [DocumentChunk] {
        [
            DocumentChunk(
                text: """
                Interest Rates and Interest Charges
                Purchase Annual Percentage Rate (APR): 19.24% to 27.49%, based on your creditworthiness and other factors. These APRs will vary with the market based on the Prime Rate.
                My Chase Loan APR: 19.24% to 27.49%, based on your creditworthiness and other factors. These APRs will vary with the market based on the Prime Rate.
                Promotional offers with fixed APRs and varying durations may be available from time to time on some accounts.
                Balance Transfer APR: 19.24% to 27.49%, based on your creditworthiness and other factors. These APRs will vary with the market based on the Prime Rate.
                Cash Advance APR: 28.49%. This APR will vary with the market based on the Prime Rate.
                Penalty APR and When It Applies: Up to 29.99%. This APR will vary with the market based on the Prime Rate. We may apply the Penalty APR to your account if you: fail to make a Minimum Payment by the date and time that it is due; or make a payment to us that is returned unpaid.
                How Long Will the Penalty APR Apply?: If we apply the Penalty APR for either of these reasons, the Penalty APR could potentially remain in effect indefinitely.
                How to Avoid Paying Interest on Purchases: Your due date will be a minimum of 21 days after the close of each billing cycle. We will not charge you interest on new purchases if you pay your entire balance or Interest Saving Balance by the due date each month. We will begin charging interest on balance transfers and cash advances on the transaction date.
                Minimum Interest Charge: None
                Credit Card Tips from the Consumer Financial Protection Bureau: To learn more about factors to consider when applying for or using a credit card, visit the website of the Consumer Financial Protection Bureau at http://www.consumerfinance.gov/learnmore.
                """,
                isTableContent: true,
                originalIndex: 0
            ),
            DocumentChunk(
                text: """
                Fees
                Annual Membership Fee: $95
                Chase Pay Over Time Fee (formerly My Chase Plan Fee; a fixed finance charge): Monthly fee of up to 1.72% of the amount of each eligible purchase transaction or amount you select to pay over time with no interest, just a fixed monthly fee. Promotional offers with lower monthly Chase Pay Over Time fees may be available from time to time on some accounts. The monthly Chase Pay Over Time fee will be determined each time a fee-based plan is created and will remain the same until the plan balance is paid in full.
                Transaction Fees
                Balance Transfers: Either $5 or 5% of the amount of each transfer, whichever is greater.
                Cash Advances: Either $10 or 5% of the amount of each transaction, whichever is greater.
                Foreign Transactions: None
                """,
                isTableContent: true,
                originalIndex: 1
            ),
            DocumentChunk(
                text: "Rates, fees, and terms may change: We have the right to change the account terms (including the APRs) in accordance with your Cardmember Agreement.",
                isTableContent: false,
                originalIndex: 2
            )
        ]
    }
}
