import SwiftUI
import FoundationModels

struct ContentView: View {
    var body: some View {
        Text("Check the console")
            .onAppear {
                // Penalty Rate + Minimum Payment Trap
                let categories: [FeeCategory] = [.penaltyRate, .minimumPaymentTrap]
                let severity = SeverityLevel.calculate(from: categories)
                print("Penalty Rate + Minimum Payment Trap: \(severity.label)")
                
                // Just junk fee
                let junk = SeverityLevel.calculate(from: [.junkFee])
                print("Junk Fee alone: \(junk.label)")
                
                // Deferred interest alone
                let deferred = SeverityLevel.calculate(from: [.deferredInterest])
                print("Deferred Interest alone: \(deferred.label)")
            }
    }
}
