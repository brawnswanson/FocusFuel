//
//  FuelBadge.swift
//  FocusFuelPlay
//
//  Created by Daniel Pressner on 18.03.2026.
//

import SwiftUI
import SwiftData

struct FuelBadge: View {
    
    var amount: Int
    var size: BadgeSize = .regular
    
    var body: some View {
        VStack(spacing: 2) {
            HStack {
                Image(systemName: "bolt.fill")
                    .font(size.iconFont)
                Text("\(amount)")
                    .font(size.font)
            }
            Text("FUEL")
                .font(size.font)
        }
        .foregroundStyle(Color.Ember.fuelText)
        .padding(.horizontal, size.horizontalPadding)
                .padding(.vertical, size.verticalPadding)
                .background(Color.Ember.fuelBackground)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Color.Ember.fuelBorder, lineWidth: 0.5)
        )
    }
    
    enum BadgeSize {
            case regular, small

            var font: Font {
                switch self {
                case .regular: return .system(size: 13, weight: .medium)
                case .small:   return .system(size: 11, weight: .medium)
                }
            }

            var iconFont: Font {
                switch self {
                case .regular: return .system(size: 11, weight: .medium)
                case .small:   return .system(size: 9, weight: .medium)
                }
            }

            var horizontalPadding: CGFloat { self == .regular ? 10 : 10 }
            var verticalPadding: CGFloat   { self == .regular ? 4  : 4 }
        }
}
