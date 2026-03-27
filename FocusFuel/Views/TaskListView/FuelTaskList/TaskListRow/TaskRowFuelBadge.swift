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
            Text("\(task.difficulty.fuelReward)")
            Image(systemName: "bolt.fill")
        }
        .font(.system(size: 12))
        .foregroundStyle(Color.Ember.fuelText.opacity(0.5))
        .padding(.horizontal, 24)
        .padding(.vertical, 6)
        .background(Color.Ember.fuelBackground.opacity(0.5))
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color.Ember.fuelBorder, lineWidth: 0.5))
      //  .animation(.easeInOut(duration: 0.3), value: task.isCompleted)
    }
}
