//
//  FilterChipBar.swift
//  FocusFuelPlay
//
//  Created by Daniel Pressner on 18.03.2026.
//

import SwiftUI

struct FilterChipBar: View {
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                Spacer()
                ForEach(TaskFilterOption.allCases, id: \.self) { filterOption in
                    FilterChip(filterOption: filterOption)
                }
                Spacer()
            }
            .padding(.vertical, 8)
        }
    }
}

struct FilterChip: View {
    
    @Environment(TaskListViewModel.self) private var vm
    var filterOption: TaskFilterOption
    
    var isSelected: Bool {
        return vm.selectedFilter == filterOption.difficulty
    }
    
    var body: some View {
        Button(action: {vm.selectedFilter = filterOption.difficulty}) {
            HStack {
                filterOption.icon?
                    .foregroundStyle(isSelected ? filterOption.tier!.subtle : filterOption.tier!.default)
                    .font(.system(size: 15))
                Text(filterOption.label)
                    .font(.system(size: 15, weight: isSelected ? .medium : .regular))
                    .foregroundStyle(labelColor)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(backgroundColor)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(borderColor, lineWidth: isSelected ? 1 : 0.5)
            )
            .animation(.easeInOut(duration: 0.15), value: isSelected)
        }
        .buttonStyle(.plain)
    }
    
    private var labelColor: Color {
        guard let tier = filterOption.tier else {
            return isSelected ? Color.Ember.textInverse : Color.Ember.textSecondary
        }
        return isSelected ? Color.Ember.textInverse : tier.text
    }
    
    private var backgroundColor: Color {
        guard let tier = filterOption.tier else {
            // "All" chip
            return isSelected ? Color.Ember.accentDefault : Color.Ember.surface
        }
        return isSelected ? tier.default : tier.subtle
    }
    
    private var borderColor: Color {
        guard let tier = filterOption.tier else {
            return isSelected ? Color.Ember.accentDefault : Color.Ember.borderSubtle
        }
        return isSelected ? tier.default : tier.subtle
    }
}

