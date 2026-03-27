//
//  BackPackItem.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 16.03.2026.
//

import Foundation
import SwiftData

// MARK: - BackpackItem

/// A purchased but not yet activated store item sitting in the user's inventory.
/// Created when the user buys something from the Store.
/// Deleted when activated or manually discarded.
@Model
final class BackpackItem {

    // MARK: Stored Properties

    var id: UUID
    var storeItemID: String        // references StoreItem.id
    var purchasedAt: Date
    var isActive: Bool             // true while a timed session is running
    var activatedAt: Date?
    var expiresAt: Date?

    // MARK: Init

    init(storeItemID: String) {
        self.id          = UUID()
        self.storeItemID = storeItemID
        self.purchasedAt = Date()
        self.isActive    = false
        self.activatedAt = nil
        self.expiresAt   = nil
    }

    // MARK: - Computed Properties

    /// Looks up the matching StoreItem from the catalog
    var storeItem: StoreItem? {
        StoreItem.catalog.first { $0.id == storeItemID }
    }

    /// Convenience accessors
    var name: String        { storeItem?.name ?? "Unknown Item" }
    var emoji: String       { storeItem?.type.emoji ?? "❓" }
    var type: StoreItemType { storeItem?.type ?? .fuelBoost }
    var durationMinutes: Int? { storeItem?.durationMinutes }

    /// Remaining seconds if currently active
    var remainingSeconds: TimeInterval? {
        guard isActive, let expiresAt else { return nil }
        let remaining = expiresAt.timeIntervalSinceNow
        return remaining > 0 ? remaining : nil
    }

    /// True if the item has expired (was active but timer ran out)
    var hasExpired: Bool {
        guard isActive, let expiresAt else { return false }
        return expiresAt.timeIntervalSinceNow <= 0
    }

    /// True if this item requires selecting a specific app to unlock
    var requiresAppSelection: Bool {
        type == .singleAppUnlock
    }

    /// True if this item is a timed item
    var isTimed: Bool {
        durationMinutes != nil
    }

    // MARK: - Activation

    /// Activates the item, setting the expiry time if it has a duration
    func activate() {
        isActive    = true
        activatedAt = Date()
        if let duration = durationMinutes {
            expiresAt = Date().addingTimeInterval(TimeInterval(duration * 60))
        }
    }

    /// Deactivates the item — call when session ends or is manually ended
    func deactivate() {
        isActive  = false
        expiresAt = nil
    }
}
