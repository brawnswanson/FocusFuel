//
//  TextBoxStyling.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 31.03.2026.
//

import SwiftUI

struct TextBoxStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(Color.Ember.textTertiary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 8)
    }
    
    enum TextBoxSize {
        case small, medium, large
    }
}
