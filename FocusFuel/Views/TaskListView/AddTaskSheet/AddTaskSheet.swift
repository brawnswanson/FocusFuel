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
        VStack(spacing: 12.0) {
            ButtonToolBar(saveAction: saveAction, isSaveable: isSaveable, isPresented: $isPresented)
            TaskNameInput(taskName: $taskName, titleFocused: $titleFocused)
            DifficultyPicker(selectedDifficulty: $selectedDifficulty)
            NotesField(notes: $notes)
            Spacer()
        }
        .padding(.horizontal, 8.0)
        .onAppear {
            titleFocused = true
            taskName = ""
            notes = ""
            selectedDifficulty = .medium
        }
    }
}

