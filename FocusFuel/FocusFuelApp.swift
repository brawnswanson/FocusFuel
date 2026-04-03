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
    @State private var fuelManager: FuelManager
    @State private var familyControlsManager = FamilyControlsManager()
    @State private var unlockSessionManager: UnlockSessionManager
    @State private var contextManager: ContextManager
    
    init() {
        let contextManager = ContextManager()
        _contextManager = State(initialValue: contextManager)
        _fuelManager = State(initialValue: FuelManager(context: contextManager.context))
        _unlockSessionManager = State(initialValue: UnlockSessionManager(context: contextManager.context))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
                .environment(fuelManager)
                .environment(contextManager)
                .environment(unlockSessionManager)
                .environment(familyControlsManager)
                .task {
                    familyControlsManager.checkFirstLaunch()
                }
        }
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
