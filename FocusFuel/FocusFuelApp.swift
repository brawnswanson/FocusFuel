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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(familyControlsManager)
                .task {
                    familyControlsManager.checkFirstLaunch()
                }
        }
        .modelContainer(for: [FuelBalance.self, FuelTask.self])
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                familyControlsManager.updateStatus()
            }
        }
    }
}
