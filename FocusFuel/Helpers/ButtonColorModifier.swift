//
//  ButtonColorModifier.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 27.03.2026.
//

import Foundation
import SwiftUI

struct TaskRowStyle: ViewModifier {
    let isCompleted: Bool
    let tier: Color.Tier

    func body(content: Content) -> some View {
        content
            .background(isCompleted ? Color.Ember.surfaceSubtle : tier.subtle)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isCompleted ? Color.Ember.borderSubtle : tier.default, lineWidth: 0.5)
            )
            .cornerRadius(12)
            .opacity(isCompleted ? 0.5 : 1)
            .animation(.easeInOut(duration: 0.2), value: isCompleted)
    }
}

extension View {
    func taskRowStyle(isCompleted: Bool, tier: Color.Tier) -> some View {
        modifier(TaskRowStyle(isCompleted: isCompleted, tier: tier))
    }
}

struct AddTaskButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(Color.Ember.textInverse)
            .padding(.horizontal, 28)
            .padding(.vertical, 16)
            .background(
                configuration.isPressed ? Color.Ember.accentDark : Color.Ember.accentDefault
            )
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.Ember.accentLight, lineWidth: 0.5)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}
