//
//  StoreItem.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 16.03.2026.
//

import Foundation
import SwiftData

// MARK: - StoreItemType

enum StoreItemType: String, Codable, CaseIterable {
    case singleAppUnlock = "singleAppUnlock"
    case allAppsUnlock   = "allAppsUnlock"
    case pcTimer         = "pcTimer"
    case fuelBoost       = "fuelBoost"
    case streakShield    = "streakShield"

    var icon: String {
        switch self {
        case .singleAppUnlock: return "lock.open.fill"
        case .allAppsUnlock:   return "globe.americas.fill"
        case .pcTimer:         return "gamecontroller.fill"
        case .fuelBoost:       return "bolt.fill"
        case .streakShield:    return "shield.fill"
        }
    }

    var emoji: String {
        switch self {
        case .singleAppUnlock: return "🔓"
        case .allAppsUnlock:   return "🌐"
        case .pcTimer:         return "🎮"
        case .fuelBoost:       return "⚡"
        case .streakShield:    return "🛡️"
        }
    }

    var category: String {
        switch self {
        case .singleAppUnlock, .allAppsUnlock: return "Unlocks"
        case .pcTimer:                          return "Timers"
        case .fuelBoost, .streakShield:         return "Power-Ups"
        }
    }
}

// MARK: - StoreItem

/// Defines an item available for purchase in the Store.
/// These are static — they don't change per user.
/// Use StoreItem.catalog to get the full list.
struct StoreItem: Identifiable, Hashable {
    let id: String           // stable identifier
    let name: String
    let description: String
    let type: StoreItemType
    let fuelCost: Int
    let durationMinutes: Int?   // nil for non-timed items

    // MARK: - Catalog

    /// All items available in the store
    static let catalog: [StoreItem] = [

        // MARK: Single App Unlocks
        StoreItem(
            id: "single_15",
            name: "Quick Unlock",
            description: "Unlock one blocked app for 15 minutes",
            type: .singleAppUnlock,
            fuelCost: 15,
            durationMinutes: 15
        ),
        StoreItem(
            id: "single_30",
            name: "Standard Unlock",
            description: "Unlock one blocked app for 30 minutes",
            type: .singleAppUnlock,
            fuelCost: 25,
            durationMinutes: 30
        ),
        StoreItem(
            id: "single_60",
            name: "Extended Unlock",
            description: "Unlock one blocked app for 60 minutes",
            type: .singleAppUnlock,
            fuelCost: 40,
            durationMinutes: 60
        ),

        // MARK: All Apps Unlocks
        StoreItem(
            id: "all_15",
            name: "Freedom Sprint",
            description: "Unlock all blocked apps for 15 minutes",
            type: .allAppsUnlock,
            fuelCost: 30,
            durationMinutes: 15
        ),
        StoreItem(
            id: "all_30",
            name: "Freedom Break",
            description: "Unlock all blocked apps for 30 minutes",
            type: .allAppsUnlock,
            fuelCost: 50,
            durationMinutes: 30
        ),
        StoreItem(
            id: "all_60",
            name: "Freedom Hour",
            description: "Unlock all blocked apps for 60 minutes",
            type: .allAppsUnlock,
            fuelCost: 80,
            durationMinutes: 60
        ),

        // MARK: PC Timers
        StoreItem(
            id: "pc_30",
            name: "Gaming Session",
            description: "30 minute countdown timer for PC or console gaming",
            type: .pcTimer,
            fuelCost: 20,
            durationMinutes: 30
        ),
        StoreItem(
            id: "pc_60",
            name: "Extended Gaming",
            description: "60 minute countdown timer for PC or console gaming",
            type: .pcTimer,
            fuelCost: 35,
            durationMinutes: 60
        ),

        // MARK: Power-Ups
        StoreItem(
            id: "boost_x2",
            name: "Fuel Boost",
            description: "Your next completed task earns double ⚡ Fuel",
            type: .fuelBoost,
            fuelCost: 10,
            durationMinutes: nil
        ),
        StoreItem(
            id: "streak_shield",
            name: "Streak Shield",
            description: "Protects your streak through one missed daily reset",
            type: .streakShield,
            fuelCost: 25,
            durationMinutes: nil
        ),
    ]

    /// Items grouped by category for the store UI
    static var catalogByCategory: [(category: String, items: [StoreItem])] {
        let categories = ["Unlocks", "Timers", "Power-Ups"]
        return categories.compactMap { category in
            let items = catalog.filter { $0.type.category == category }
            return items.isEmpty ? nil : (category: category, items: items)
        }
    }
}
