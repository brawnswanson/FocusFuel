//
//  TaskListProgressView.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 27.03.2026.
//

import SwiftUI

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
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.Ember.textSecondary)
                Spacer()
                Text("\(completed) of \(total)")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.Ember.textTertiary)
            }

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
        .background(Color.Ember.surface)
       
    }
}

#Preview {
    TaskListProgressView(completed: 5, total: 10)
}
