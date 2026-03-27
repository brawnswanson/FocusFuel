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
    
    var tier: Color.Tier {
        switch self {
        case .boss:   return .boss
        case .medium: return .medium
        case .quick:  return .quick
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
