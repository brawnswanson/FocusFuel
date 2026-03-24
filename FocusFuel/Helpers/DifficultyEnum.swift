//
//  DifficultyEnum.swift
//  FocusFuelPlay
//
//  Created by Daniel Pressner on 19.03.2026.
//

import Foundation
import SwiftUI

enum Difficulty: String, CaseIterable, Codable {
    case boss = "boss"
    case medium = "medium"
    case quick = "quick"
    
    var accentColor: Color {
        switch self {
        case .boss: return Color.Tier.boss.default
        case .medium: return Color.Tier.medium.default
        case .quick: return Color.Tier.quick.default
        }
    }
    
    var borderColor: Color {
        switch self {
        case .boss: return Color.Tier.boss.dark
        case .medium: return Color.Tier.medium.dark
        case .quick: return Color.Tier.quick.dark
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .boss: return Color.Tier.boss.default
        case .medium: return Color.Tier.medium.default
        case .quick: return Color.Tier.quick.default
        }
    }
    
    var textColor: Color {
        switch self {
        case .boss: return Color.Tier.boss.text
        case .medium: return Color.Tier.medium.text
        case .quick: return Color.Tier.quick.text
        }
    }
    
    var icon: Image {
        switch self {
        case .boss: return Image(systemName: "circle.fill")
        case .medium: return Image(systemName: "circle.fill")
        case .quick: return Image(systemName: "circle.fill")
        }
    }
    
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
    
    var fuelReward: Int {
        switch self {
        case .boss: return 45
        case .medium: return 20
        case .quick: return 8
        }
    }
    
    var label: String {
        switch self {
        case .boss: return "Boss"
        case .medium: return "Medium"
        case .quick: return "Quick"
        }
    }
    
}
