//
//  BackPackViewModel.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 03.04.2026.
//

import Foundation
import SwiftUI

@MainActor
@Observable
class BackPackViewModel {
    
    var unlockSessionManager: UnlockSessionManager
    var fuelManager: FuelManager
    var familyControlsManager: FamilyControlsManager
    var activeSession: ActiveSession? { unlockSessionManager.activeSession }
    var queue: [QueuedSession] { unlockSessionManager.queue }
    var inventory: [UnlockSession] { unlockSessionManager.inventory}
    var displayEmptyState: Bool { unlockSessionManager.inventory.isEmpty && !unlockSessionManager.hasActiveSession && unlockSessionManager.queue.isEmpty }
    
    init(unlockSessionManager: UnlockSessionManager, fuelManager: FuelManager, familyControlsManager: FamilyControlsManager) {
        self.unlockSessionManager = unlockSessionManager
        self.fuelManager = fuelManager
        self.familyControlsManager = familyControlsManager
    }
    
    func activate(session: UnlockSession, familyControlsManager: FamilyControlsManager) {
        unlockSessionManager.activate(session: session, familyControlsManager: familyControlsManager)
    }
    
    func cancelActiveSession() -> Int {
        return 0
    }
    
    func refundFuel(amount: Int) {
        
    }
}
