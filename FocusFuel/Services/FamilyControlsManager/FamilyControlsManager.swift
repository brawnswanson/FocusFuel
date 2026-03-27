//
//  FamilyControlsManager.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 27.03.2026.
//

import Foundation
import FamilyControls
import Combine

@MainActor
class FamilyControlsManager: ObservableObject {
    
    static let shared = FamilyControlsManager()
    
    @Published var authorizationStatus: AuthorizationStatus = .notDetermined
    @Published var activitySelection: FamilyActivitySelection = FamilyActivitySelection()
    
    private let hasLaunchedKey = "hasLaunchedBefore"
    private let selectionKey = "savedActivitySelection"
    
    private init() {
        updateStatus()
        loadSelection()
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
    
    func saveSelection() {
        do {
            let encoded = try JSONEncoder().encode(activitySelection)
            UserDefaults.standard.set(encoded, forKey: selectionKey)
        } catch {
            print("Failed to save activity selection: \(error)")
        }
    }
    
    func loadSelection() {
        guard let data = UserDefaults.standard.data(forKey: selectionKey) else { return }
        do {
            activitySelection = try JSONDecoder().decode(FamilyActivitySelection.self, from: data)
        } catch {
            print("Failed to load activity selection: \(error)")
        }
    }
    
    var hasSelectedApps: Bool {
        !activitySelection.applicationTokens.isEmpty
    }
}
