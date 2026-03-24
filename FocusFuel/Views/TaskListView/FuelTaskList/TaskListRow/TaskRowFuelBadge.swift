//
//  TaskRowFuelBadge.swift
//  FocusFuelPlay
//
//  Created by Daniel Pressner on 19.03.2026.
//

import SwiftUI

struct TaskRowFuelBadge: View {
    
    var task: FuelTask
    
    var body: some View {
        VStack(spacing: 2) {
            Text("+\(45)")
                .font(.subheadline.bold())
                .foregroundStyle(task.isCompleted ? Color.secondary.opacity(0.5) : .yellow)
            Image(systemName: "bolt.fill")
                .font(.caption2)
                .foregroundStyle(task.isCompleted ? Color.secondary.opacity(0.5) : .yellow)
        }
        .frame(minWidth: 45.0)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.yellow.opacity(task.isCompleted ? 0.03 : 0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.yellow.opacity(task.isCompleted ? 0.05 : 0.25), lineWidth: 1)
                )
        )
        .animation(.easeInOut(duration: 0.3), value: task.isCompleted)
    }
}
