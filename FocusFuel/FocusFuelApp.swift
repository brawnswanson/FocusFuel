//
//  FocusFuelApp.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 13.03.2026.
//

import SwiftUI
import SwiftData

@main
struct FocusFuelApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var familyControlsManager = FamilyControlsManager.shared
    @StateObject private var fuelManager: FuelManager = FuelManager.shared
    @StateObject private var unlockSessionManager: UnlockSessionManager = UnlockSessionManager.shared
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(familyControlsManager)
                .environmentObject(fuelManager)
                .environmentObject(unlockSessionManager)
                .task {
                    familyControlsManager.checkFirstLaunch()
                }
        }
        .modelContainer(for: [FuelBalance.self, FuelTask.self])
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                familyControlsManager.updateStatus()
                if !unlockSessionManager.hasActiveSession {
                    familyControlsManager.applyShield()
                }
                unlockSessionManager.handleExpiration(familyControlsManager: familyControlsManager)
            }
        }
    }
}
