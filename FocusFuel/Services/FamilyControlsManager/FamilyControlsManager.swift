//
//  FamilyControlsManager.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 27.03.2026.
//

import Foundation
import FamilyControls
import ManagedSettings
import Combine
import SwiftUI
import SwiftData

@MainActor
@Observable
class FamilyControlsManager {
    
    //var context: ModelContext
    
    var authorizationStatus: AuthorizationStatus = .notDetermined
    var activitySelection: FamilyActivitySelection = FamilyActivitySelection()
    var isLocked: Bool = false
    
    private let store: ManagedSettingsStore = ManagedSettingsStore()
    private let hasLaunchedKey: String = "hasLaunchedBefore"
    private let selectionKey: String = "savedActivitySelection"
    private let isLockedKey: String = "isLocked"
    private let sharedDefaults: UserDefaults = UserDefaults(suiteName: "pressner.apps.FocusFuel") ?? UserDefaults.standard
    
    
    init() {
       // self.context = context
        updateStatus()
        loadSelection()
        isLocked = UserDefaults.standard.bool(forKey: isLockedKey)
    }
    
    func updateStatus() {
        authorizationStatus = AuthorizationCenter.shared.authorizationStatus
    }
    
    func checkFirstLaunch() {
        let hasLaunched = UserDefaults.standard.bool(forKey: hasLaunchedKey)
        if !hasLaunched {
            UserDefaults.standard.set(true, forKey: hasLaunchedKey)
            requestAuthorization()
        }
    }
    
    func requestAuthorization() {
        Task {
            do {
                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                updateStatus()
            } catch {
                updateStatus()
                print("FamilyControls authorization error: \(error)")
            }
        }
    }
    
    func applyShield() {
        store.shield.applications = activitySelection.applicationTokens
    }
    
    var hasSelectedApps: Bool {
        !activitySelection.applicationTokens.isEmpty
    }
    
    func saveSelection() {
        do {
            let encoded: Data = try JSONEncoder().encode(activitySelection)
            sharedDefaults.set(encoded, forKey: selectionKey)
        } catch {
            print("Failed to save activity selection: \(error)")
        }
    }
    
    func loadSelection() {
        guard let data: Data = sharedDefaults.data(forKey: selectionKey) else { return }
        do {
            activitySelection = try JSONDecoder().decode(FamilyActivitySelection.self, from: data)
        } catch {
            print("Failed to load activity selection: \(error)")
        }
    }
}
