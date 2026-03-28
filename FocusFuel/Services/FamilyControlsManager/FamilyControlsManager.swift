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

@MainActor
class FamilyControlsManager: ObservableObject {
    
    static let shared = FamilyControlsManager()
    
    @Published var authorizationStatus: AuthorizationStatus = .notDetermined
    @Published var activitySelection: FamilyActivitySelection = FamilyActivitySelection()
    @Published var isLocked: Bool = false
    
    private let store: ManagedSettingsStore = ManagedSettingsStore()
    private let hasLaunchedKey: String = "hasLaunchedBefore"
    private let selectionKey: String = "savedActivitySelection"
    private let isLockedKey: String = "isLocked"
    private let sharedDefaults: UserDefaults = UserDefaults(suiteName: "pressner.apps.FocusFuel") ?? UserDefaults.standard

    
    private init() {
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
    
    func lockApps() {
        store.shield.applications = activitySelection.applicationTokens
        isLocked = true
        UserDefaults.standard.set(true, forKey: isLockedKey)
    }
    
    func unlockApps() {
        store.shield.applications = nil
        isLocked = false
        UserDefaults.standard.set(false, forKey: isLockedKey)
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
