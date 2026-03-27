//
//  AddTaskSheet.swift
//  FocusFuelPlay
//
//  Created by Daniel Pressner on 19.03.2026.
//

import SwiftUI

struct AddTaskSheet: View {
    
    
    @Binding var isPresented: Bool
    
    @Binding var taskName: String
    @Binding var selectedDifficulty: Difficulty
    @Binding var notes: String
    var saveAction: () -> Void
    
    @FocusState var titleFocused: Bool
    
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
                TaskNameInput(taskName: $taskName, titleFocused: $titleFocused)
                    .padding(16)
                Divider()
                    .background(Color.Ember.borderSubtle)
                Text("Difficulty")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.Ember.textTertiary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                DifficultyPicker(selectedDifficulty: $selectedDifficulty)
                    .padding(.horizontal, 16)
                NotesField(notes: $notes)
                Spacer()
            }
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
                    Button("Save") {
                        saveAction()
                        isPresented = false
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(isSaveable ? Color.Ember.accentDefault : Color.Ember.textTertiary)
                    .disabled(!isSaveable)
                    .animation(.easeInOut(duration: 0.15), value: isSaveable)
                }
            }
            .onAppear {
                titleFocused = true
                taskName = ""
                notes = ""
                selectedDifficulty = .medium
            }
        }
    }
}

