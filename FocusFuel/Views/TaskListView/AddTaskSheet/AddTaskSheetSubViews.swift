//
//  AddTaskSheetSubViews.swift
//  FocusFuelPlay
//
//  Created by Daniel Pressner on 21.03.2026.
//

import SwiftUI

struct TaskNameInput: View {
    
    @Binding var taskName: String
    var titleFocused: FocusState<Bool>.Binding
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Task name")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color.Ember.textTertiary)
            TextField("What do you need to do?", text: $taskName)
                .font(.system(size: 16))
                .foregroundStyle(Color.Ember.textPrimary)
                .padding(12)
                .background(Color.Ember.surfaceSubtle)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            taskName.isEmpty ? Color.Ember.borderSubtle : Color.Ember.accentDefault,
                            lineWidth: taskName.isEmpty ? 0.5 : 1
                        )
                )
                .animation(.easeInOut(duration: 0.15), value: taskName.isEmpty)
        }
        .focused(titleFocused)
    }
}

struct DifficultyPicker: View {
    
    @Binding var selectedDifficulty: Difficulty
    
    var body: some View {
        VStack(spacing: 1.0) {
            ForEach(Difficulty.allCases, id: \.self) { difficulty in
                DifficultyPickerRow(selectedDifficulty: $selectedDifficulty, difficulty: difficulty)
                    .padding(.vertical, 4)
            }
        }
    }
}

struct DifficultyPickerRow: View {
    
    @Binding var selectedDifficulty: Difficulty
    var difficulty: Difficulty
    var isSelected: Bool {
        selectedDifficulty == difficulty
    }
    
    var body: some View {
        Button(action: { selectedDifficulty = difficulty }) {
            HStack(alignment: .center, spacing: 12) {
                Circle()
                    .fill(difficulty.tier.default)
                    .frame(width: 10, height: 10)
                VStack(alignment: .leading, spacing: 2) {
                    Text(difficulty.label)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(isSelected ? difficulty.tier.text : Color.Ember.textPrimary)
                    Text(difficulty.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // Fuel reward
                FuelBadge(amount: difficulty.fuelReward, size: .small)
                ZStack {
                    Circle()
                        .fill(isSelected ? difficulty.tier.default : Color.clear)
                        .frame(width: 22, height: 22)
                    Circle()
                        .stroke(
                            isSelected ? difficulty.tier.default : Color.Ember.borderDefault,
                            lineWidth: 1.5
                        )
                        .frame(width: 22, height: 22)
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(Color.Ember.textInverse)
                    }
                }
                .animation(.easeInOut(duration: 0.15), value: isSelected)
            }
            .padding(12)
            .background(isSelected ? difficulty.tier.subtle : Color.Ember.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? difficulty.tier.default : Color.Ember.borderSubtle,
                        lineWidth: isSelected ? 1 : 0.5
                    )
            )
            .animation(.easeInOut(duration: 0.15), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}

struct NotesField: View {
    
    @Binding var notes: String
    
    var body: some View {
        TextField("Notes", text: $notes, axis: .vertical)
            .font(.body)
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground),
                        in: RoundedRectangle(cornerRadius: 12))
    }
}
