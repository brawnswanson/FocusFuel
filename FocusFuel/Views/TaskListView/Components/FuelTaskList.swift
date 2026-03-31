//
//  FuelTaskList.swift
//  FocusFuelPlay
//
//  Created by Daniel Pressner on 18.03.2026.
//

import SwiftUI

struct FuelTaskList: View {
    
    var viewModel: TaskListViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.pendingTasks) { task in
                    TaskListRow(viewModel: viewModel, task: task)
                }
                if (viewModel.completedTasks.count > 0) {
                    VStack {
                        Text("Completed")
                            .font(.caption.bold())
                            .foregroundStyle(.secondary)
                            .textCase(.uppercase)
                            .tracking(2)
                        ForEach(viewModel.completedTasks) { task in
                            TaskListRow(viewModel: viewModel, task: task)
                        }
                    }
                }
            }
            .animation(.easeInOut(duration: 0.25), value: viewModel.pendingTasks)
        }
    }
}

struct TaskListRow: View {
    
    var viewModel: TaskListViewModel
    var task: FuelTask
    
    var body: some View {
        Button(action: {
            
        }) {
            HStack(spacing:14) {
                TaskRowCompleteIndicator(task: task)
                TaskRowBody(task: task)
                Spacer()
                TaskRowFuelBadge(difficulty: task.difficulty)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .taskRowStyle(isCompleted: task.isCompleted, tier: task.difficulty.tier)
    }
}

struct TaskRowCompleteIndicator: View {
    
    var task: FuelTask
    
    var body: some View {
        ZStack {
            Circle()
                .fill(task.isCompleted ? task.difficulty.tier.default : Color.clear)
                .frame(width: 24, height: 24)
            Circle()
                .stroke(task.isCompleted ? task.difficulty.tier.default : task.difficulty.tier.default.opacity(0.5), lineWidth: 1.5)
                .frame(width: 24, height: 24)
            
            if task.isCompleted {
                Image(systemName: "checkmark")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Color.Ember.textInverse)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: task.isCompleted)
    }
}

struct TaskRowBody: View {
    
    var task: FuelTask
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(task.title)
                .font(.body.weight(task.isCompleted ? .regular : .semibold))
                .foregroundStyle(.textPrimary)
                .strikethrough(task.isCompleted, color: .secondary)
                .lineLimit(2)
        }
    }
}

struct TaskRowFuelBadge: View {
    
    let difficulty: Difficulty
    
    var body: some View {
        VStack(spacing: 2) {
            Text("\(difficulty.fuelReward)")
            Image(systemName: "bolt.fill")
        }
        .font(.system(size: 12))
        .foregroundStyle(Color.Ember.fuelText.opacity(0.5))
        .padding(.horizontal, 24)
        .padding(.vertical, 6)
        .background(Color.Ember.fuelBackground.opacity(0.5))
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color.Ember.fuelBorder, lineWidth: 0.5))
    }
}

