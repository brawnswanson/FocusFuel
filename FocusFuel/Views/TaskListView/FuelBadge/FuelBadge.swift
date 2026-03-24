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
                Image(systemName: "bolt.fill").foregroundStyle(.yellow)
                Text("\(fuelBalance.first?.currentBalance ?? 99)")
                    .font(.title2.bold())
                    .foregroundStyle(.yellow)
            }
            Text("FUEL")
                .font(.caption2.bold())
                .foregroundStyle(.yellow.opacity(0.7))
                .tracking(2)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.yellow.opacity(0.12), in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(.yellow.opacity(0.3), lineWidth: 1))
        .onAppear {
            if fuelBalance.count == 0 {
                let newFuelBalance = FuelBalance()
                context.insert(newFuelBalance)
            }
        }
    }
}
