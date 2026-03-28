//
//  FocusFuelActivityMonitor.swift
//  FocusFuelDeviceActivity
//
//  Created by Daniel Pressner on 28.03.2026.
//

import Foundation
import DeviceActivity
import ManagedSettings
import FamilyControls

class FocusFuelActivityMonitor: DeviceActivityMonitor {
    
    private let store: ManagedSettingsStore = ManagedSettingsStore()
    
    // Called when the unlock window starts — remove the shield
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        store.shield.applications = nil
    }
    
    // Called when the unlock window ends — reapply the shield
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        loadAndApplyShield()
    }
    
    // MARK: - Helpers
    
    private func loadAndApplyShield() {
        guard let data: Data = UserDefaults(suiteName: "pressner.apps.FocusFuel")?.data(forKey: "savedActivitySelection"),
              let selection: FamilyActivitySelection = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)
        else { return }
        store.shield.applications = selection.applicationTokens
    }
}
