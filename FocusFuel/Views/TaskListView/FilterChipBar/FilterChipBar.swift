//
//  FilterChipBar.swift
//  FocusFuelPlay
//
//  Created by Daniel Pressner on 18.03.2026.
//

import SwiftUI

struct FilterChipBar: View {
    
    @Binding var selectedFilter: Difficulty?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                Spacer()
                ForEach(TaskFilterOption.allCases, id: \.self) { filterOption in
                    FilterChip(filterOption: filterOption, selectedFilter: $selectedFilter)
                }
                Spacer()
            }
            .padding(.vertical, 8)
        }
    }
}
