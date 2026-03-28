//
//  FuelBadge.swift
//  FocusFuelPlay
//
//  Created by Daniel Pressner on 18.03.2026.
//

import SwiftUI
import SwiftData

struct FuelBadge: View {
    
    @EnvironmentObject var fuelManager: FuelManager
    var size: BadgeSize = .regular
    var staticValue: Int? = nil
    
    var body: some View {
        VStack(spacing: 2) {
            HStack {
                Image(systemName: "bolt.circle.fill")
                    .font(size.iconFont)
                    .foregroundStyle(Color.Ember.accentDefault)
                if let value = staticValue {
                    Text("\(value)")
                        .font(size.font)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.Ember.accentText)
                } else {
                    Text("\(fuelManager.balance)")
                        .font(size.font)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.Ember.accentText)
                }
                
            }
        }
        .padding(.horizontal, size.horizontalPadding)
        .padding(.vertical, size.verticalPadding)
        .background(Color.Ember.accentSubtle)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.Ember.borderSubtle, lineWidth: 1.0)
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
