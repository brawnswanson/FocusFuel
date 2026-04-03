//
//  FuelManager.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 28.03.2026.
//

import Foundation
import SwiftData
import Combine
import SwiftUI

@MainActor
@Observable
class FuelManager {
    
    let context: ModelContext
    
    private var fuelBalance: FuelBalance? = nil
    
    init(context: ModelContext) {
        self.context = context
        loadOrCreateBalance()
    }
    
    var balance: Int {
        fuelBalance?.currentBalance ?? 0
    }
    
    var totalEarned: Int {
        fuelBalance?.totalEarned ?? 0
    }
    
    var totalSpent: Int {
        fuelBalance?.totalSpent ?? 0
    }
    
    private func loadOrCreateBalance() {
        let descriptor: FetchDescriptor<FuelBalance> = FetchDescriptor<FuelBalance>()
        do {
            let results: [FuelBalance] = try context.fetch(descriptor)
            if let existing: FuelBalance = results.first {
                fuelBalance = existing
            } else {
                let newBalance: FuelBalance = FuelBalance()
                context.insert(newBalance)
                try context.save()
                fuelBalance = newBalance
            }
        } catch {
            print("Failed to load FuelBalance: \(error)")
        }
    }
    
    func addFuel(amount: Int) {
        guard let fuel: FuelBalance = fuelBalance else { return }
        fuel.currentBalance += amount
        fuel.totalEarned += amount
        saveFuelBalance()
    }
    
    func deductFuelForTaskToggle(amount: Int) {
        guard let fuel: FuelBalance = fuelBalance else { return }
        fuel.currentBalance = fuel.currentBalance > amount ? fuel.currentBalance - amount : 0
        saveFuelBalance()
    }
    
    func deductFuel(amount: Int) {
        guard let fuel: FuelBalance = fuelBalance else { return }
        guard fuel.currentBalance >= amount else { return }
        fuel.currentBalance -= amount
        fuel.totalSpent += amount
        saveFuelBalance()
        loadOrCreateBalance()
    }
    
    func refundFuel(amount: Int) {
        guard let fuel: FuelBalance = fuelBalance else { return }
        fuel.currentBalance += amount
        saveFuelBalance()
    }
    
    private func saveFuelBalance() {
        do {
            try context.save()
        } catch {
            print("Failed to save FuelBalance: \(error)")
        }
    }
}
