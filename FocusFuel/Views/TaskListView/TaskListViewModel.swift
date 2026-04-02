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
    
    var fuelBalance: FuelBalance?
    var tasks: [FuelTask] = []
    var selectedFilter: Difficulty? = nil
    
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
    
    func filterTasks(_ tasks:[FuelTask], by selectedFilter: Difficulty?) -> [FuelTask] {
        if let filterBy = selectedFilter {
            return tasks.filter { $0.difficulty == filterBy }
        }
        else { return tasks }
    }
    
    func changeTaskStatus(task: FuelTask, fuelManager: FuelManager) {
        print(task.isCompleted)
        if !task.isCompleted {
            fuelManager.addFuel(amount: task.difficulty.fuelReward)
        } else {
            fuelManager.deductFuelForTaskToggle(amount: task.difficulty.fuelReward)
        }
        task.isCompleted.toggle()
        saveContext()
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
