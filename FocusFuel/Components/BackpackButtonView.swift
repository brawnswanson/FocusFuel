//
//  BackpackButtonView.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 30.03.2026.
//

import SwiftUI

struct BackpackButtonView: View {
    
    @Binding var inventorySheetIsPresented: Bool
    var inventoryCount: Int
    
    var body: some View {
        Button(action: {
            inventorySheetIsPresented = true
        }) {
            HStack(spacing: 6) {
                Image(systemName: "backpack")
                    .font(.subheadline)
                if inventoryCount > 0 {
                    Text("\(inventoryCount)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.Ember.textInverse)
                        .frame(minWidth: 16, minHeight: 16)
                        .background(Color.Ember.accentDefault)
                        .clipShape(Circle())
                }
            }
            .foregroundStyle(Color.Ember.accentDefault)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.Ember.accentSubtle)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.Ember.borderSubtle, lineWidth: 1)
            )
        }
    }
}
