//
//  FuelEarnedBanner.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 13.03.2026.
//

import SwiftUI

// MARK: - FuelEarnedBanner

/// A toast-style banner that slides in from the top when Fuel is earned.
/// Automatically dismisses after a short delay.
struct FuelEarnedBanner: View {

    // MARK: Properties

    let fuelAmount: Int
    let taskTitle: String
    let difficulty: Difficulty
    @Binding var isVisible: Bool

    // MARK: Private State

    @State private var offset: CGFloat = -120
    @State private var opacity: Double = 0

    // MARK: Difficulty Styling

    private var accentColor: Color {
        switch difficulty {
        case .boss:   return .red
        case .medium: return .orange
        case .quick:  return .green
        }
    }

    private var congratsMessage: String {
        switch difficulty {
        case .boss:   return "Boss task crushed! 💪"
        case .medium: return "Nice work!"
        case .quick:  return "Quick win!"
        }
    }

    // MARK: Body

    var body: some View {
        VStack {
            banner
                .offset(y: offset)
                .opacity(opacity)
            Spacer()
        }
        .allowsHitTesting(false)
        .onChange(of: isVisible) { _, newValue in
            if newValue { animateIn() }
        }
    }

    // MARK: - Banner

    private var banner: some View {
        HStack(spacing: 14) {
            // Icon
            ZStack {
                Circle()
                    .fill(accentColor.opacity(0.15))
                    .frame(width: 44, height: 44)
               // Text(difficulty.icon)
                 //   .font(.title3)
            }

            // Text content
            VStack(alignment: .leading, spacing: 2) {
                Text(congratsMessage)
                    .font(.subheadline.bold())
                    .foregroundStyle(.primary)
                Text(taskTitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            // Fuel amount
            VStack(spacing: 1) {
                Text("+\(fuelAmount)")
                    .font(.title3.bold())
                    .foregroundStyle(.yellow)
                Text("⚡ FUEL")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(.yellow.opacity(0.7))
                    .tracking(2)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.regularMaterial)
                .shadow(color: accentColor.opacity(0.2), radius: 16, y: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(accentColor.opacity(0.25), lineWidth: 1)
                )
        )
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    // MARK: - Animation

    private func animateIn() {
        // Slide in
        withAnimation(.spring(duration: 0.4, bounce: 0.4)) {
            offset = 0
            opacity = 1
        }

        // Slide out after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            withAnimation(.easeIn(duration: 0.3)) {
                offset = -120
                opacity = 0
            }
        }

        // Reset binding
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
            isVisible = false
        }
    }
}

// MARK: - Preview

#Preview("Boss Task") {
    ZStack {
        Color(.systemGroupedBackground).ignoresSafeArea()
        FuelEarnedBanner(
            fuelAmount: 45,
            taskTitle: "Call the dentist",
            difficulty: .boss,
            isVisible: .constant(true)
        )
    }
}

#Preview("Medium Task") {
    ZStack {
        Color(.systemGroupedBackground).ignoresSafeArea()
        FuelEarnedBanner(
            fuelAmount: 20,
            taskTitle: "Reply to emails",
            difficulty: .medium,
            isVisible: .constant(true)
        )
    }
}

#Preview("Quick Win") {
    ZStack {
        Color(.systemGroupedBackground).ignoresSafeArea()
        FuelEarnedBanner(
            fuelAmount: 8,
            taskTitle: "Drink a glass of water",
            difficulty: .quick,
            isVisible: .constant(true)
        )
    }
}
