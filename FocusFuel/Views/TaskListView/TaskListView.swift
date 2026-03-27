//
//  TaskListView.swift
//  FocusFuelPlay
//
//  Created by Daniel Pressner on 18.03.2026.
//

import SwiftUI
import SwiftData

struct TaskListView: View {
    
    @Environment(\.modelContext) var context
    @Query var tasks: [FuelTask]
    @Query var fuelBalances: [FuelBalance]
    
    @State private var isAddTaskSheetPresented: Bool = false
    @State private var selectedFilter: Difficulty? = nil
    
    @State var newTaskName: String = ""
    @State var newTaskDifficulty: Difficulty = .medium
    @State var newTaskNotes: String = ""
    
    var pendingTasks: [FuelTask] {
        filterTasks(tasks, by: selectedFilter).filter { $0.isCompleted == false }
    }
    
    var completedTasks: [FuelTask] {
        filterTasks(tasks, by: selectedFilter).filter { $0.isCompleted == true }
    }
    
    var fuelBalance: FuelBalance {
        if let first = fuelBalances.first {
            return first
        } else {
            fatalError("No FuelBalance found")
        }
    }
    
    var totalTasks: Int {
        completedTasks.count + pendingTasks.count
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TaskListProgressView(completed: completedTasks.count, total: totalTasks)
                    Spacer()
                    FuelBadge()
                }
                FilterChipBar(selectedFilter: $selectedFilter)
                FuelTaskList(pendingTasks: pendingTasks, completedTasks: completedTasks, fuelBalance: fuelBalance)
                AddTaskButton(isPresented: $isAddTaskSheetPresented)
            }
            .padding(.horizontal, 8.0)
            .padding(.bottom, 4.0)
        }
        .sheet(isPresented: $isAddTaskSheetPresented) {
            AddTaskSheet(isPresented: $isAddTaskSheetPresented, taskName: $newTaskName, selectedDifficulty: $newTaskDifficulty, notes: $newTaskNotes, saveAction: addTask)
        }
    }
    
    func filterTasks(_ tasks:[FuelTask], by selectedFilter: Difficulty?) -> [FuelTask] {
        if let filterBy = selectedFilter {
            return tasks.filter { $0.difficulty == filterBy }
        }
        else { return tasks }
    }
    
    func addTask() {
        let newFuelTask = FuelTask(title: newTaskName, notes: newTaskNotes, difficulty: newTaskDifficulty)
        context.insert(newFuelTask)
        saveContext()
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error Saving")
            }
        }
    }
}
