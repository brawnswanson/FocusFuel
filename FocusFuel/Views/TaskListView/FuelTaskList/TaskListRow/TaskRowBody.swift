//
//  TaskRowBody.swift
//  FocusFuelPlay
//
//  Created by Daniel Pressner on 19.03.2026.
//

import SwiftUI

struct TaskRowBody: View {
    
    var task: FuelTask
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(task.title)
                .font(.body.weight(task.isCompleted ? .regular : .semibold))
                .foregroundStyle(.textPrimary)
                .strikethrough(task.isCompleted, color: .secondary)
                .lineLimit(2)
            
         /*   HStack(spacing: 6) {
                task.difficulty.icon
                    .foregroundStyle(task.difficulty.accentColor)
             
                // Notes indicator
                if !task.notes.isEmpty {
                    Text("·")
                        .foregroundStyle(.tertiary)
                    Image(systemName: "note.text")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }*/
        }
    }
}

#Preview {
    TaskRowBody(task: FuelTask(title: "Do the thing", notes: "here are some notes", difficulty: .quick))
}
