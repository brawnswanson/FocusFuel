//
//  UnlockSession.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 28.03.2026.
//

import Foundation

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
