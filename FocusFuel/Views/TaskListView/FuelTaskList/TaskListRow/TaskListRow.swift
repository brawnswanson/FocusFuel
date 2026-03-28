//
//  TaskListRow.swift
//  FocusFuelPlay
//
//  Created by Daniel Pressner on 19.03.2026.
//

import SwiftUI
import SwiftData

struct TaskListRow: View {

    @Environment(\.modelContext) var context
    @EnvironmentObject var fuelManager: FuelManager
    var task: FuelTask
    
    var body: some View {
        Button(action: {
            changeTaskStatus()
            saveContext()
        }) {
            HStack(spacing:14) {
                TaskRowCompleteIndicator(task: task)
                TaskRowBody(task: task)
                Spacer()
                TaskRowFuelBadge(task: task)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .taskRowStyle(isCompleted: task.isCompleted, tier: task.difficulty.tier)
    }
    
    func changeTaskStatus() {
        if task.isCompleted {
            fuelManager.deductFuelForTaskToggle(amount: task.difficulty.fuelReward)
        } else {
            fuelManager.addFuel(amount: task.difficulty.fuelReward)
        }
        task.isCompleted.toggle()
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
