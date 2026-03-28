//
//  UnlockSession.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 28.03.2026.
//

import Foundation

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
        case .thirtyMinutes: return 120
        case .oneHour: return 300
        case .twoHours: return 700
        }
    }
    
    var timeInterval: TimeInterval {
        Double(fuelCost) * 60.0
    }
}

struct UnlockSession: Codable, Identifiable {
    let id: UUID
    let duration: SessionDuration
    let purchasedAt: Date
    
    init(duration: SessionDuration) {
        self.id = UUID()
        self.duration = duration
        self.purchasedAt = Date.now
    }
}

struct ActiveSession: Codable {
    let sessionId: UUID
    let duration: SessionDuration
    let startDate: Date
    let endDate: Date
    let fuelCost: Int
    
    init(from session: UnlockSession) {
        self.sessionId = session.id
        self.duration = session.duration
        self.startDate = Date.now
        self.endDate = Date.now.addingTimeInterval(session.duration.timeInterval)
        self.fuelCost = session.duration.fuelCost
    }
    
    var fractionUsed: Double {
        let elapsed: TimeInterval = Date.now.timeIntervalSince(startDate)
        let total: TimeInterval = endDate.timeIntervalSince(startDate)
        return min(elapsed / total, 1.0)
    }
    
    var refundAmount: Int {
        let penalty: Double = pow(1.0 - fractionUsed, 2.0)
        return Int((Double(fuelCost) * penalty).rounded())
    }
    
    var timeRemaining: TimeInterval {
        return max(endDate.timeIntervalSinceNow, 0)
    }
    
    var isExpired: Bool {
        return Date.now >= endDate
    }
}
