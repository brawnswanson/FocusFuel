//
//  UnlockSession.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 01.04.2026.
//

import Foundation
import SwiftData

@Model
class UnlockSession {
    var id: UUID
    var duration: SessionDuration
    var purchasedAt: Date
    
    init(duration: SessionDuration) {
        self.id = UUID()
        self.duration = duration
        self.purchasedAt = Date.now
    }
}

enum SessionDuration: Int, Codable, CaseIterable, Identifiable {
    case fifteenMinutes = 15
    case thirtyMinutes = 30
    case oneHour = 60
    case twoHours = 120
    
    var id: Int { rawValue }
    
    var displayName: String {
        switch self {
            case .fifteenMinutes: return "15 Minutes"
        case .thirtyMinutes: return "30 Minutes"
            case .oneHour: return "1 Hour"
        case .twoHours: return "2 Hours"
        }
    }
    
    var fuelCost: Int {
        switch self {
            case .fifteenMinutes: return 50
        case .thirtyMinutes: return 90
        case .oneHour: return 150
        case .twoHours: return 250
        }
    }
    
    var timeInterval: TimeInterval {
        Double(self.rawValue) * 60.0
    }
}
