//
//  UnlockSessionManager.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 28.03.2026.
//

import Foundation
import FamilyControls
import ManagedSettings
import DeviceActivity
import Combine
import SwiftData

@MainActor
@Observable
class UnlockSessionManager {
    
    var context: ModelContext
    var inventory: [UnlockSession] = []
    var activeSession: ActiveSession? = nil
    var queue: [QueuedSession] = []
    
    private let store: ManagedSettingsStore = ManagedSettingsStore()
    private let activityCenter: DeviceActivityCenter = DeviceActivityCenter()
    private let activityName: DeviceActivityName = DeviceActivityName("pressner.apps.FocusFuel")
    
    private let inventoryKey: String = "unlockSessionInventory"
    private let activeSessionKey: String = "activeUnlockSession"
    private let queueKey: String = "unlockSessionQueue"
    
    init(context: ModelContext) {
        self.context = context
        loadInventory()
        loadActiveSession()
        loadQueue()
    }
    
    // MARK: - Purchasing
    
    func purchase(duration: SessionDuration) {
        let session: UnlockSession = UnlockSession(duration: duration)
        context.insert(session)
        saveInventory()
    }
    
    // MARK: - Activation
    
    func activate(session: UnlockSession, familyControlsManager: FamilyControlsManager) {
        guard activeSession == nil else {
            enqueue(session: session)
            return
        }
        removeFromInventory(sessionId: session.id)
        let active: ActiveSession = ActiveSession(from: session)
        activeSession = active
        saveActiveSession()
        
        // Immediately remove the shield
        store.shield.applications = nil
        print("Shield removed immediately on activation")
        
        scheduleActivity(startDate: active.startDate, endDate: active.endDate)
        scheduleExpirationCheck(familyControlsManager: familyControlsManager, endDate: active.endDate)
    }
    
    // MARK: - Scheduling
    
    private func scheduleActivity(startDate: Date, endDate: Date) {
        let dateInterval: DateInterval = DateInterval(start: startDate, end: endDate)
        let schedule: DeviceActivitySchedule = DeviceActivitySchedule(
            intervalStart: Calendar.current.dateComponents([.hour, .minute, .second], from: dateInterval.start),
            intervalEnd: Calendar.current.dateComponents([.hour, .minute, .second], from: dateInterval.end),
            repeats: false
        )
        do {
            try activityCenter.startMonitoring(activityName, during: schedule)
            print("Activity scheduled from \(startDate) to \(endDate)")
        } catch {
            print("Failed to schedule device activity: \(error)")
        }
    }
    
    private func stopScheduledActivity() {
        activityCenter.stopMonitoring([activityName])
    }
    
    // MARK: - Queuing
    
    private func enqueue(session: UnlockSession) {
        removeFromInventory(sessionId: session.id)
     //   queue.append(session)
        saveQueue()
    }
    
    private func activateNext(familyControlsManager: FamilyControlsManager) {
        guard !queue.isEmpty else { return }
      //  let next: UnlockSession = queue.removeFirst()
        saveQueue()
       // activate(session: next, familyControlsManager: familyControlsManager)
    }
    
    // MARK: - Cancellation & Refund
    
    func cancelActiveSession(familyControlsManager: FamilyControlsManager) -> Int {
        guard let session: ActiveSession = activeSession else { return 0 }
        let refund: Int = session.refundAmount
        stopScheduledActivity()
        store.shield.applications = familyControlsManager.activitySelection.applicationTokens
        activeSession = nil
        saveActiveSession()
        activateNext(familyControlsManager: familyControlsManager)
        return refund
    }
    
    // MARK: - Expiration
    
    private func scheduleExpirationCheck(familyControlsManager: FamilyControlsManager, endDate: Date) {
        let delay: TimeInterval = endDate.timeIntervalSinceNow
        guard delay > 0 else { return }
        Task {
            try? await Task.sleep(for: .seconds(delay))
            handleExpiration(familyControlsManager: familyControlsManager)
        }
    }
    
    func handleExpiration(familyControlsManager: FamilyControlsManager) {
        guard let session: ActiveSession = activeSession, session.isExpired else { return }
        activeSession = nil
        saveActiveSession()
        activateNext(familyControlsManager: familyControlsManager)
    }
    
    // MARK: - Persistence
    
    private func saveInventory() {
        do {
            try context.save()
            loadInventory()
        } catch {
            print("Error saving unlock sessions")
        }
    }
    
    private func loadInventory() {
        let descriptor = FetchDescriptor<UnlockSession>()
        do {
            let results = try context.fetch(descriptor)
            inventory = results
        } catch {
            print("Error fetching Inventory")
        }
    }
    
    private func saveActiveSession() {
        // guard let encoded: Data = try? JSONEncoder().encode(activeSession) else {
        //    UserDefaults.standard.removeObject(forKey: activeSessionKey)
        //    return
        // }
        // UserDefaults.standard.set(encoded, forKey: activeSessionKey)
    }
    
    private func loadActiveSession() {
        let descriptor = FetchDescriptor<ActiveSession>()
        do {
            let results = try context.fetch(descriptor)
            if let first = results.first {
                activeSession = first
            }
        } catch {
            print("Error fetching Inventory")
        }
    }
    
    private func saveQueue() {
        //   guard let encoded: Data = try? JSONEncoder().encode(queue) else { return }
        //   UserDefaults.standard.set(encoded, forKey: queueKey)
    }
    
    private func loadQueue() {
        let descriptor = FetchDescriptor<QueuedSession>()
        do {
            let results = try context.fetch(descriptor)
            if !results.isEmpty {
                queue = results
            } else {
                queue = []
            }
        } catch {
            print("Error fetching Inventory")
        }
    }
    
    // MARK: - Helpers
    
    private func removeFromInventory(sessionId: UUID) {
        inventory.removeAll { $0.id == sessionId }
        saveInventory()
    }
    
    var hasActiveSession: Bool {
        return activeSession != nil
    }
    
    var queueCount: Int {
        return queue.count
    }
}
