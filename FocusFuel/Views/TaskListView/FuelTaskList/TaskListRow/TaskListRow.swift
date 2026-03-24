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
    var task: FuelTask
     
    var body: some View {
        Button(action: {task.isCompleted.toggle()
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
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(task.difficulty.accentColor.opacity(task.isCompleted ? 0.03 : 0.25))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                   .stroke(task.difficulty.borderColor.opacity(task.isCompleted ? 0.1 : 0.25), lineWidth: 1)
            )
        }
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
