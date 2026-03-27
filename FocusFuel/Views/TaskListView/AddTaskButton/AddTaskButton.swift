//
//  AddTaskButton.swift
//  FocusFuelPlay
//
//  Created by Daniel Pressner on 19.03.2026.
//

import SwiftUI

struct AddTaskButton: View {
    
    @Binding var isPresented: Bool
    
    var body: some View {
        Button(action: { isPresented.toggle()}) {
            HStack(spacing: 8) {
                Image(systemName: "plus")
                Text("Add Task")
            }
        }
        .buttonStyle(AddTaskButtonStyle())
        .shadow(color: Color.Ember.accentDefault.opacity(0.3), radius: 12, x: 0, y: 4)
        .padding(.bottom, 8)
    }
}
