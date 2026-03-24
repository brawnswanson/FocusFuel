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
            HStack {
                Spacer()
                FilterChip(filterOption: nil, selectedFilter: $selectedFilter)
                ForEach(Difficulty.allCases, id: \.self) { filterOption in
                    FilterChip(filterOption: filterOption, selectedFilter: $selectedFilter)
                }
                Spacer()
            }
        }
    }
}
