//
//  TaskListViewModel.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 31.03.2026.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class TaskListViewModel {
    
    private let context: ModelContext
    
    var tasks: [FuelTask] = []
    var selectedFilter: Difficulty? = nil
    var fuelBalances: [FuelBalance] = []
    
    var fuelBalance: FuelBalance? {
        fuelBalances.first
    }
    
    var pendingTasks: [FuelTask] {
        filterTasks(tasks, by: selectedFilter).filter { $0.isCompleted == false }
    }
    
    var completedTasks: [FuelTask] {
        filterTasks(tasks, by: selectedFilter).filter { $0.isCompleted == true }
    }
    
    var totalTasks: Int {
        completedTasks.count + pendingTasks.count
    }
    
    init(context: ModelContext) {
        self.context = context
        fetchTasks()
        if let isThereAFuelBalance = fuelBalance {}
        else {
            createFirstFuelBalance()
        }
    }
    
    func fetchTasks() {
        let descriptor = FetchDescriptor<FuelTask>()
        do {
            let results = try context.fetch(descriptor)
            tasks = results
        } catch {
            print("Error fetching tasks")
        }
    }
    
    func fetchFuelBalances() {
        let descriptor = FetchDescriptor<FuelBalance>()
        do {
            let results = try context.fetch(descriptor)
            fuelBalances = results
        } catch {
            print("Error fetching tasks")
        }
    }
    
    func createFirstFuelBalance() {
        if fuelBalances.isEmpty {
            let newFuelBalance = FuelBalance()
            context.insert(newFuelBalance)
            saveContext()
            fetchFuelBalances()
        }
    }
    
    func filterTasks(_ tasks:[FuelTask], by selectedFilter: Difficulty?) -> [FuelTask] {
        if let filterBy = selectedFilter {
            return tasks.filter { $0.difficulty == filterBy }
        }
        else { return tasks }
    }
    
    func changeTaskStatus(task: FuelTask) {
        if task.isCompleted {
            fuelBalance?.updateFuelBalance(adding: false, amount: task.difficulty.fuelReward)
        } else {
            fuelBalance?.updateFuelBalance(adding: true, amount: task.difficulty.fuelReward)
        }
        task.isCompleted.toggle()
        saveContext()
        fetchFuelBalances()
    }
    
    func addTask(taskName: String, notes: String, difficulty: Difficulty) {
        let newFuelTask = FuelTask(title: taskName, notes: notes, difficulty: difficulty)
        context.insert(newFuelTask)
        saveContext()
        fetchTasks()
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving data")
        }
    }
}
