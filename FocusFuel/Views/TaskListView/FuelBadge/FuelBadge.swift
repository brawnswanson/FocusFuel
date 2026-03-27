//
//  FuelBadge.swift
//  FocusFuelPlay
//
//  Created by Daniel Pressner on 18.03.2026.
//

import SwiftUI
import SwiftData

struct FuelBadge: View {
    
    @Environment(\.modelContext) private var context
    @Query var fuelBalance: [FuelBalance]
    
    var body: some View {
        VStack(spacing: 2) {
            HStack {
                Image(systemName: "bolt.fill")
                Text("\(fuelBalance.first?.currentBalance ?? 99)")
            }
            Text("FUEL")
        }
        .foregroundStyle(Color.Ember.fuelText)
        .padding(.horizontal, 20)
        .padding(.vertical, 6)
        .background(Color.Ember.fuelBackground)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Color.Ember.fuelBorder, lineWidth: 0.5)
        )
    }
}
