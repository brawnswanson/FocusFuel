//
//  ContextManager.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 01.04.2026.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
@Observable
class ContextManager {
    
    let container: ModelContainer
    let context: ModelContext
    
    init() {
        self.container = try! ModelContainer(for: FuelTask.self, FuelBalance.self)
        self.context = container.mainContext
    }
    
}
