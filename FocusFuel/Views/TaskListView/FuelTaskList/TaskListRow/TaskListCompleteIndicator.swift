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
