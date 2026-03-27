//
//  FilterEnum.swift
//  FocusFuelPlay
//
//  Created by Daniel Pressner on 18.03.2026.
//

import Foundation
import SwiftUI

enum TaskFilterOption: String, CaseIterable {
    case all = "all"
    case boss = "boss"
    case medium = "medium"
    case quick = "quick"
    
    var label: String {
        switch self {
        case .all: return "All"
        case .boss: return "Boss"
        case .medium: return "Medium"
        case .quick: return "Quick"
        }
    }
    
    var icon: Image? {
        switch self {
        case .all: return nil
        case .boss: return Image(systemName: "circle.fill")
        case .medium: return Image(systemName: "circle.fill")
        case .quick: return Image(systemName: "circle.fill")
        }
    }
    
    var tier: Color.Tier? {
        switch self {
        case .all:    return nil
        case .boss:   return .boss
        case .medium: return .medium
        case .quick:  return .quick
        }
    }
    
    var imageName: String {
        switch self {
        case .all: return "bolt.fill"
        default: return "circle.fill"
        }
    }
    
    var imageColor: Color {
        switch self {
        case .all: return .yellow
        case .boss: return .red
        case .medium: return .orange
        case .quick: return .green
        }
    }
    
    var difficulty: Difficulty? {
        switch self {
        case .all:    return nil
        case .boss:   return .boss
        case .medium: return .medium
        case .quick:  return .quick
        }
    }
}
