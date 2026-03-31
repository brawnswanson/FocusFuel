//
//  CountdownView.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 30.03.2026.
//

import SwiftUI
import Combine

struct CountdownView: View {
    
    let endDate: Date
    @State private var timeRemaining: TimeInterval = 0.0
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Text(timeString)
            .font(.system(size: 48, weight: .bold, design: .monospaced))
            .foregroundStyle(Color.Ember.accentDefault)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.Ember.accentSubtle)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .onAppear {
                timeRemaining = max(endDate.timeIntervalSinceNow, 0)
            }
            .onReceive(timer) { _ in
                timeRemaining = max(endDate.timeIntervalSinceNow, 0)
            }
    }
    
    private var timeString: String {
        let hours: Int = Int(timeRemaining) / 3600
        let minutes: Int = (Int(timeRemaining) % 3600) / 60
        let seconds: Int = Int(timeRemaining) % 60
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}
