//
//  AddTaskSheet.swift
//  FocusFuelPlay
//
//  Created by Daniel Pressner on 19.03.2026.
//

import SwiftUI
import SwiftData

struct AddTaskSheet: View {
    
    @Binding var isPresented: Bool
    @State var taskName: String = ""
    @State var selectedDifficulty: Difficulty = .medium
    @State var notes: String = ""
    @FocusState var titleFocused: Bool
    
    var viewModel: TaskListViewModel
    
    var isSaveable: Bool {
        if taskName.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12.0) {
                TaskNameInput(text: $taskName, titleFocused: $titleFocused)
                Divider().background(Color.Ember.borderSubtle)
                Text("Difficulty")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.Ember.textTertiary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                DifficultyPickerList(selectedDifficulty: $selectedDifficulty)
                TextField("Notes", text: $notes, axis: .vertical)
                    .font(.body)
                    .padding(14)
                    .background(Color.surfaceSubtle, in: RoundedRectangle(cornerRadius: 12))
                Spacer()
            }
            .padding(.horizontal, 16)
            .background(Color.Ember.appBackground)
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundStyle(Color.Ember.textSecondary)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveTaskClicked() }
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(isSaveable ? Color.Ember.accentDefault : Color.Ember.textTertiary)
                        .disabled(!isSaveable)
                        .animation(.easeInOut(duration: 0.15), value: isSaveable)
                }
            }
            .onAppear { titleFocused = true }
        }
    }
    
    func saveTaskClicked() {
        viewModel.addTask(taskName: taskName, notes: notes, difficulty: selectedDifficulty)
        isPresented = false
    }
}


struct TaskNameInput: View {
    
    @Binding var text: String
    var titleFocused: FocusState<Bool>.Binding
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Task name")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color.Ember.textTertiary)
            TextField("What do you need to do?", text: $text)
                .font(.system(size: 16))
                .foregroundStyle(Color.Ember.textPrimary)
                .padding(12)
                .background(Color.Ember.surfaceSubtle)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            text.isEmpty ? Color.Ember.borderSubtle : Color.Ember.accentDefault,
                            lineWidth: text.isEmpty ? 0.5 : 1
                        )
                )
                .animation(.easeInOut(duration: 0.15), value: text.isEmpty)
                .focused(titleFocused)
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
                FuelBadge(fuelBalance: 88, size: .regular, staticValue: difficulty.fuelReward)
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

struct DifficultyPickerList: View {
    
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

#if DEBUG
struct PreviewContainer {
    static func make(withSampleData: Bool = true) -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: FuelTask.self, configurations: config)
        return container
    }
}
#endif

