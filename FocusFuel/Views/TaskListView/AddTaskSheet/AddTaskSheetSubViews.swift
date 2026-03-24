//
//  AddTaskSheetSubViews.swift
//  FocusFuelPlay
//
//  Created by Daniel Pressner on 21.03.2026.
//

import SwiftUI

struct ButtonToolBar: View {
    
    var saveAction: () -> Void
    var isSaveable: Bool
    @Binding var isPresented: Bool
    
    var body: some View {
        HStack {
            CancelButton(cancelAction: { isPresented = false })
            SaveButton(saveAction: saveAction, isSaveable: isSaveable, isPresented: $isPresented)
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 8.0)
    }
}

struct TaskNameInput: View {
    
    @Binding var taskName: String
    var titleFocused: FocusState<Bool>.Binding
    
    var body: some View {
        VStack(alignment: .leading) {
            Label("Task", systemImage: "bolt.fill")
                .font(.caption.bold())
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
                .tracking(1)

            TextField("What do you need to do?", text: $taskName, axis: .vertical)
                .font(.body)
                .focused(titleFocused)
                .background(Color(.secondarySystemGroupedBackground),
                            in: RoundedRectangle(cornerRadius: 12))
                .lineLimit(3)
        }
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
            HStack(spacing: 14) {
                // Label + description
                VStack(alignment: .leading, spacing: 2) {
                    Text(difficulty.label)
                        .font(.subheadline.bold())
                        .foregroundStyle(isSelected ? difficulty.accentColor : .primary)
                    Text(difficulty.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // Fuel reward
                HStack {
                    Text("+\(difficulty.fuelReward)")
                        .font(.caption.bold())
                        .foregroundStyle(isSelected ? .yellow : .secondary)
                    Image(systemName: "bolt.fill")
                        .foregroundStyle(.yellow)
                }
                
                // Selection indicator
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? difficulty.accentColor : Color(.tertiaryLabel))
                    .font(.body)
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected
                          ? difficulty.accentColor.opacity(0.15)
                          : difficulty.accentColor.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(difficulty.accentColor.opacity(0.3))
            )
        }
        .buttonStyle(.plain)
    }
}


struct CancelButton: View {
    
    var cancelAction: () -> Void
    
    var body: some View {
        Button("Cancel") {
            cancelAction()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .foregroundStyle(.white)
        .background(.red, in: Capsule())
        //.shadow(color: .red.opacity(0.4), radius: 12, y: 4)
        Spacer()
    }
}

struct SaveButton: View {
    
    var saveAction: () -> Void
    var isSaveable: Bool
    @Binding var isPresented: Bool
    
    var body: some View {
        Button("Save") {
           saveAction()
           isPresented = false
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .foregroundStyle(.white)
        .background(isSaveable ? .green : .green.opacity(0.5), in: Capsule())
        //.shadow(color: .green.opacity(0.4), radius: 12, y: 4)
        .disabled(!isSaveable)
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
