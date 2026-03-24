//
//  Tasks.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 13.03.2026.
//

import Foundation
import SwiftData

// MARK: - Difficulty Tier

enum Difficulty: String, Codable, CaseIterable {
    case boss   = "boss"
    case medium = "medium"
    case quick  = "quick"

    /// Display label shown in the UI
    var label: String {
        switch self {
        case .boss:   return "Boss Task"
        case .medium: return "Medium"
        case .quick:  return "Quick Win"
        }
    }

    /// Emoji indicator shown alongside the task
    var icon: String {
        switch self {
        case .boss:   return "🔴"
        case .medium: return "🟡"
        case .quick:  return "🟢"
        }
    }

    /// Fuel (⚡) awarded on completion
    var fuelReward: Int {
        switch self {
        case .boss:   return 45
        case .medium: return 20
        case .quick:  return 8
        }
    }

    /// A short description shown during task creation
    var description: String {
        switch self {
        case .boss:
            return "Hard to start — calls, finances, admin"
        case .medium:
            return "Moderate effort — emails, cleaning, errands"
        case .quick:
            return "Low friction — 5 mins or less"
        }
    }
}

// MARK: - Task Model

@Model
final class Task {

    // MARK: Stored Properties

    var id: UUID
    var title: String
    var notes: String
    var difficulty: Difficulty
    var isCompleted: Bool
    var createdAt: Date
    var completedAt: Date?

    // MARK: Init

    init(
        title: String,
        notes: String = "",
        difficulty: Difficulty = .medium
    ) {
        self.id          = UUID()
        self.title       = title
        self.notes       = notes
        self.difficulty  = difficulty
        self.isCompleted = false
        self.createdAt   = Date()
        self.completedAt = nil
    }

    // MARK: Computed Properties

    /// Fuel earned — only meaningful once completed
    var fuelReward: Int {
        difficulty.fuelReward
    }

    /// True if the task was completed today (used for daily reset logic later)
    var isCompletedToday: Bool {
        guard let completedAt else { return false }
        return Calendar.current.isDateInToday(completedAt)
    }
}
