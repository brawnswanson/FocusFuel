//
//  FilterChip.swift
//  FocusFuelPlay
//
//  Created by Daniel Pressner on 18.03.2026.
//

import SwiftUI

struct FilterChip: View {
    
    var filterOption: Difficulty?
    @Binding var selectedFilter: Difficulty?
    
    var isSelected: Bool {
        return selectedFilter == filterOption
    }
    
    var body: some View {
        Button(action: {selectedFilter = filterOption }) {
            HStack {
                if let filterOption {
                    filterOption.icon.foregroundStyle(filterOption.backgroundColor)
                    Text(filterOption.label)
                } else {
                    Image(systemName: "bolt.fill").foregroundStyle(.yellow)
                    Text("All")
                }
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(isSelected ? Color.green.opacity(0.75) : Color(.secondarySystemBackground), in: .capsule)
            .foregroundStyle(isSelected ? .black : .secondary)
            .animation(.easeInOut(duration: 0.3), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}
