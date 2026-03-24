//
//  TaskListCompleteIndicator.swift
//  FocusFuelPlay
//
//  Created by Daniel Pressner on 19.03.2026.
//

import SwiftUI

struct TaskRowCompleteIndicator: View {
    
    var task: FuelTask
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(task.difficulty.accentColor.opacity(task.isCompleted ? 0.3 : 0.6), lineWidth: 2)
                .frame(width: 26, height: 26)
            if task.isCompleted {
                Circle()
                    .fill(task.difficulty.accentColor.opacity(0.3))
                    .frame(width: 26, height: 26)
                Image(systemName: "checkmark")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(task.difficulty.accentColor)
            }
        }
        .animation(.spring(duration: 0.3, bounce: 0.5), value: task.isCompleted)
    }
}
