//
//  FuelBalance.swift
//  FocusFuelPlay
//
//  Created by Daniel Pressner on 19.03.2026.
//

import Foundation
import SwiftData

@Model
class FuelBalance {
    var id: UUID = UUID()
    var currentBalance: Int = 0
    var totalEarned: Int = 0
    var totalSpent: Int = 0
    
    init() {}
}
