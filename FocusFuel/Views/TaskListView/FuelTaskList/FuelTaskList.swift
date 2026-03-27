//
//  FuelTaskList.swift
//  FocusFuelPlay
//
//  Created by Daniel Pressner on 18.03.2026.
//

import SwiftUI
import SwiftData

struct FuelTaskList: View {
    
    var pendingTasks: [FuelTask]
    var completedTasks: [FuelTask]
    var fuelBalance: FuelBalance
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(pendingTasks) { task in
                    TaskListRow(task: task, fuelBalance: fuelBalance)
                }
                if (completedTasks.count > 0) {
                    VStack {
                        Text("Completed")
                            .font(.caption.bold())
                            .foregroundStyle(.secondary)
                            .textCase(.uppercase)
                            .tracking(2)
                        ForEach(completedTasks) { task in
                            TaskListRow(task: task, fuelBalance: fuelBalance)
                        }
                    }
                }
            }
            .animation(.easeInOut(duration: 0.25), value: pendingTasks)
        }
    }
}
