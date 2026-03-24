//
//  CoinBurstView.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 13.03.2026.
//

import SwiftUI

// MARK: - CoinBurstView

/// Displays an animated burst of ⚡ particles when a task is completed.
/// Overlay this on top of the task list and trigger via the `isVisible` binding.
struct CoinBurstView: View {

    // MARK: Properties

    let fuelAmount: Int
    let difficulty: Difficulty
    @Binding var isVisible: Bool

    // MARK: Private State

    @State private var particles: [Particle] = []
    @State private var showAmount: Bool = false

    // MARK: Particle Model

    struct Particle: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var opacity: Double
        var scale: CGFloat
        var rotation: Double
        let symbol: String
        let color: Color
    }

    // MARK: Difficulty Styling

    private var accentColor: Color {
        switch difficulty {
        case .boss:   return .red
        case .medium: return .orange
        case .quick:  return .green
        }
    }

    private var particleCount: Int {
        switch difficulty {
        case .boss:   return 14
        case .medium: return 9
        case .quick:  return 6
        }
    }

    private var symbols: [String] {
        switch difficulty {
        case .boss:   return ["⚡️", "⚡️", "⭐", "💥", "⚡️"]
        case .medium: return ["⚡️", "⚡️", "✨"]
        case .quick:  return ["⚡️", "✨"]
        }
    }

    // MARK: Body

    var body: some View {
        ZStack {
            // Particles
            ForEach(particles) { particle in
                Text(particle.symbol)
                    .font(.system(size: 22))
                    .scaleEffect(particle.scale)
                    .rotationEffect(.degrees(particle.rotation))
                    .opacity(particle.opacity)
                    .position(x: particle.x, y: particle.y)
            }

            // Fuel amount label
            if showAmount {
                VStack(spacing: 2) {
                    Text("+\(fuelAmount)")
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .foregroundStyle(.yellow)
                    Text("⚡ FUEL")
                        .font(.caption.bold())
                        .foregroundStyle(.yellow.opacity(0.8))
                        .tracking(3)
                }
                .shadow(color: .yellow.opacity(0.6), radius: 12)
                .transition(.scale(scale: 0.5).combined(with: .opacity))
            }
        }
        .allowsHitTesting(false) // never intercept taps
        .onAppear {
            triggerBurst()
        }
    }

    // MARK: - Animation

    private func triggerBurst() {
        print("burst triggered")
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else { return }

        let centerX = window.bounds.midX
        let centerY = window.bounds.midY * 0.6 // slightly above center

        // Spawn particles
        particles = (0..<particleCount).map { i in
            let angle = (Double(i) / Double(particleCount)) * 360.0
            let radius = CGFloat.random(in: 20...60)
            return Particle(
                x: centerX + cos(angle * .pi / 180) * radius * 0.3,
                y: centerY + sin(angle * .pi / 180) * radius * 0.3,
                opacity: 1.0,
                scale: CGFloat.random(in: 0.6...1.2),
                rotation: Double.random(in: -30...30),
                symbol: symbols[i % symbols.count],
                color: accentColor
            )
        }

        // Show amount label
        withAnimation(.spring(duration: 0.3, bounce: 0.5)) {
            showAmount = true
        }

        // Animate particles outward
        withAnimation(.easeOut(duration: 0.7)) {
            for i in particles.indices {
                let angle = (Double(i) / Double(particleCount)) * 360.0
                let radius = CGFloat.random(in: 80...160)
                particles[i].x = centerX + cos(angle * .pi / 180) * radius
                particles[i].y = centerY + sin(angle * .pi / 180) * radius
                particles[i].rotation = Double.random(in: -180...180)
            }
        }

        // Fade particles out
        withAnimation(.easeIn(duration: 0.4).delay(0.4)) {
            for i in particles.indices {
                particles[i].opacity = 0
                particles[i].scale = 0.3
            }
        }

        // Hide amount label and reset
        withAnimation(.easeIn(duration: 0.3).delay(0.8)) {
            showAmount = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            particles = []
            isVisible = false
        }
    }
}

// MARK: - Preview

#Preview("Boss Burst") {
    ZStack {
        Color(.systemGroupedBackground).ignoresSafeArea()
        CoinBurstView(
            fuelAmount: 45,
            difficulty: .boss,
            isVisible: .constant(true)
        )
    }
}

#Preview("Quick Burst") {
    ZStack {
        Color(.systemGroupedBackground).ignoresSafeArea()
        CoinBurstView(
            fuelAmount: 8,
            difficulty: .quick,
            isVisible: .constant(true)
        )
    }
}
