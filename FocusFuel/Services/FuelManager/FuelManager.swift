//
//  FuelManager.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 28.03.2026.
//

import Foundation
import SwiftData
import Combine

@MainActor
class FuelManager: ObservableObject {
    
    static let shared: FuelManager = FuelManager()
    
    @Published var balance: Int = 0
    @Published var totalEarned: Int = 0
    @Published var totalSpent: Int = 0
    
    private var modelContext: ModelContext? = nil
    private var fuelBalance: FuelBalance? = nil
    
    private init() {}
    
    // MARK: - Setup
    
    func configure(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadOrCreateBalance()
    }
    
    // MARK: - Loading
    
    private func loadOrCreateBalance() {
        guard let context: ModelContext = modelContext else { return }
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
            syncPublishedValues()
        } catch {
            print("Failed to load FuelBalance: \(error)")
        }
    }
    
    // MARK: - Sync
    
    private func syncPublishedValues() {
        guard let fuel: FuelBalance = fuelBalance else { return }
        balance = fuel.currentBalance
        totalEarned = fuel.totalEarned
        totalSpent = fuel.totalSpent
    }
    
    // MARK: - Transactions
    
    func addFuel(amount: Int) {
        guard let fuel: FuelBalance = fuelBalance,
              let context: ModelContext = modelContext else { return }
        fuel.currentBalance += amount
        fuel.totalEarned += amount
        save(context: context)
        syncPublishedValues()
    }
    
    func deductFuelForTaskToggle(amount: Int) {
        guard let fuel: FuelBalance = fuelBalance,
              let context: ModelContext = modelContext else { return }
        fuel.currentBalance = fuel.currentBalance > amount ? fuel.currentBalance - amount : 0
        save(context: context)
        syncPublishedValues()
    }
    
    func deductFuel(amount: Int) -> Bool {
        guard let fuel: FuelBalance = fuelBalance,
              let context: ModelContext = modelContext else { return false }
        guard fuel.currentBalance >= amount else { return false }
        fuel.currentBalance -= amount
        fuel.totalSpent += amount
        save(context: context)
        syncPublishedValues()
        return true
    }
    
    func refundFuel(amount: Int) {
        guard let fuel: FuelBalance = fuelBalance,
              let context: ModelContext = modelContext else { return }
        fuel.currentBalance += amount
        save(context: context)
        syncPublishedValues()
    }
    
    // MARK: - Persistence
    
    private func save(context: ModelContext) {
        do {
            try context.save()
        } catch {
            print("Failed to save FuelBalance: \(error)")
        }
    }
}
