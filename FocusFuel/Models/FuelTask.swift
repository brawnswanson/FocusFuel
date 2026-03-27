//
//  FuelTask.swift
//  FocusFuelPlay
//
//  Created by Daniel Pressner on 18.03.2026.
//

import Foundation
import SwiftData

@Model
class FuelTask {
    
    var id: UUID
    var title: String
    var notes: String
    var difficulty: Difficulty
    var isCompleted: Bool
    var createdAt: Date
    var completedAt: Date?
    
    init(title: String, notes: String?, difficulty: Difficulty) {
        self.id = UUID()
        self.title = title
        if let newNotes = notes { self.notes = newNotes } else { self.notes = "" }
        self.difficulty = difficulty
        self.isCompleted = false
        self.createdAt = Date()
        self.completedAt = nil
    }
}
