//
//  DeviceActivityMonitorExtension.swift
//  FocusFuelDeviceActivity
//
//  Created by Daniel Pressner on 28.03.2026.
//
import Foundation
import DeviceActivity
import ManagedSettings
import FamilyControls

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        store.shield.applications = nil
        print("started")
        // Handle the start of the interval.
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        loadAndApplyShield()
        // Handle the end of the interval.
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        
        // Handle the event reaching its threshold.
    }
    
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        
        // Handle the warning before the interval starts.
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        
        // Handle the warning before the interval ends.
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        
        // Handle the warning before the event reaches its threshold.
    }
    
    private let store: ManagedSettingsStore = ManagedSettingsStore()
        
        // MARK: - Helpers
        
        private func loadAndApplyShield() {
            guard let data: Data = UserDefaults(suiteName: "group.pressner.apps.FocusFuel")?.data(forKey: "savedActivitySelection"),
                  let selection: FamilyActivitySelection = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)
            else { return }
            store.shield.applications = selection.applicationTokens
        }
}
