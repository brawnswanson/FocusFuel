//
//  StoreViewModel.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 01.04.2026.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
@Observable
class StoreViewModel {
    
    let fuelManager: FuelManager
    let unlockSessionManager: UnlockSessionManager
    let familyControlsManager: FamilyControlsManager
    
    var purchaseErrorMessage: String = ""
    var isPurchaseErrorPresented: Bool = false
    var inventorySheetIsPresented: Bool = false
    
    init(context: ModelContext, fuelManager: FuelManager, unlockSessionManager: UnlockSessionManager, familyControlsManager: FamilyControlsManager) {
        self.fuelManager = fuelManager
        self.unlockSessionManager = unlockSessionManager
        self.familyControlsManager = familyControlsManager
    }
    
    func handlePurchase(duration: SessionDuration) {
        unlockSessionManager.purchase(duration: duration)
       fuelManager.deductFuel(amount: duration.fuelCost)
    }
}
