//
//  UnlockSession.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 01.04.2026.
//

import Foundation
import SwiftData

@Model
class QueuedSession {
    var id: UUID
    var duration: SessionDuration
    var queuedAt: Date
    
    init(duration: SessionDuration) {
        self.id = UUID()
        self.duration = duration
        self.queuedAt = Date.now
    }
}
