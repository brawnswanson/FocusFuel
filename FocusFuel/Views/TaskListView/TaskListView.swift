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
    @EnvironmentObject var fuelManager: FuelManager
    @Environment(TaskListViewModel.self) var viewModel
    
    var tasks: [FuelTask] {
        viewModel.tasks
    }
    
    @State private var isAddTaskSheetPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    FuelBadge(fuelBalance: viewModel.fuelBalance?.currentBalance ?? 0, size: .regular)
                    Spacer()
                    TaskListProgressView(completed: viewModel.completedTasks.count, total: viewModel.totalTasks)
                }
                FilterChipBar()
                FuelTaskList(viewModel: viewModel)
                AddTaskButton(isPresented: $isAddTaskSheetPresented)
            }
            .padding(.horizontal, 8.0)
            .padding(.bottom, 4.0)
            .background(Color.Ember.appBackground)
        }
        .sheet(isPresented: $isAddTaskSheetPresented) {
            AddTaskSheet(isPresented: $isAddTaskSheetPresented, viewModel: viewModel)
        }
    }
}

struct AddTaskButton: View {
    
    @Binding var isPresented: Bool
    
    var body: some View {
        Button(action: { isPresented.toggle()}) {
            HStack(spacing: 8) {
                Image(systemName: "plus")
                Text("Add Task")
            }
        }
        .buttonStyle(AddTaskButtonStyle())
        .shadow(color: Color.Ember.accentDefault.opacity(0.3), radius: 12, x: 0, y: 4)
        .padding(.bottom, 8)
    }
}

struct TaskListProgressView: View {
    
    var completed: Int
    var total: Int

    private var progress: Double {
        guard total > 0 else { return 0 }
        return min(Double(completed) / Double(total), 1.0)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Today's Progress")
                    .foregroundStyle(Color.Ember.textSecondary)
                Spacer()
                Text("\(completed) of \(total)")
                    .foregroundStyle(Color.Ember.textTertiary)
            }
            .font(.system(size: 13, weight: .medium))

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    // Track
                    Capsule()
                        .fill(Color.Ember.accentSubtle)
                        .frame(height: 6)

                    // Fill
                    Capsule()
                        .fill(progress == 1 ? Color.Ember.accentDark : Color.Ember.accentDefault)
                        .frame(width: geo.size.width * progress, height: 6)
                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: progress)
                }
            }
            .frame(height: 6)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.Ember.appBackground)
       
    }
}

