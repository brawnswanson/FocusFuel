//
//  LockedApp.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 14.03.2026.
//

import Foundation
import SwiftData

// MARK: - LockedApp Model

/// Represents an app the user wants to lock behind Fuel.
/// The iconSymbol and name are manual entries for now.
/// In Phase 3 these will be replaced with FamilyActivitySelection tokens.
@Model
final class LockedApp {
    var id: UUID
    var name: String
    var iconSymbol: String
    var fuelCostPer15Min: Int
    var isCurrentlyUnlocked: Bool
    var unlockedUntil: Date?

    init(name: String, iconSymbol: String, fuelCostPer15Min: Int = 15) {
        self.id                  = UUID()
        self.name                = name
        self.iconSymbol          = iconSymbol
        self.fuelCostPer15Min    = fuelCostPer15Min
        self.isCurrentlyUnlocked = false
        self.unlockedUntil       = nil
    }

    /// Remaining seconds if currently unlocked
    var remainingSeconds: TimeInterval? {
        guard isCurrentlyUnlocked, let unlockedUntil else { return nil }
        let remaining = unlockedUntil.timeIntervalSinceNow
        return remaining > 0 ? remaining : nil
    }

    /// Fuel cost for a given session duration
    func fuelCost(for minutes: Int) -> Int {
        (minutes / 15) * fuelCostPer15Min
    }
}

// MARK: - SessionDuration

enum SessionDuration: Int, CaseIterable {
    case fifteen = 15
    case thirty  = 30
    case sixty   = 60

    var label: String { "\(rawValue) min" }
    var fuelMultiplier: Int { rawValue / 15 }
}
