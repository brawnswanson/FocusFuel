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
            HStack {
                Image(systemName: "plus")
                Text("Add Task")
            }
            .foregroundStyle(.black)
            .font(.title)
            .padding(.horizontal, 8.0)
            .padding(.vertical, 6.0)
        }
        .background(.green.opacity(0.75), in: Capsule())
        .shadow(color: .green.opacity(0.4), radius: 12, y: 4)
    }
}
