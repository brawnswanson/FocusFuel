//
//  StoreViewModel.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 01.04.2026.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
class StoreViewModel {
    
    private let context: ModelContext
    
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func handlePurchase(duration: SessionDuration) {
      /*  let result: (success: Bool, message: String) = unlockSessionManager.purchase(
            duration: duration,
            fuelBalance: FuelManager.shared.balance
        )
        if result.success {
            let didDeduct: Bool = FuelManager.shared.deductFuel(amount: duration.fuelCost)
            if !didDeduct {
                purchaseErrorMessage = "Not enough Fuel for a \(duration.displayName) session."
                isPurchaseErrorPresented = true
            }
        } else {
            purchaseErrorMessage = result.message
            isPurchaseErrorPresented = true
        } */
    }
}
