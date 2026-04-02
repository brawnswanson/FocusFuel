//
//  ActiveSessionView.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 30.03.2026.
//

import SwiftUI

struct ActiveSessionView: View {
    
    @Environment(UnlockSessionManager.self) var unlockSessionManager
    @Binding var showCancelConfirmation: Bool
    
    var active: ActiveSession
    
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "lock.open.fill")
                .font(.system(size: 70))
                .foregroundStyle(Color.Tier.quick.default)
            
            VStack(spacing: 8) {
                Text("Apps Unlocked")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.Ember.textPrimary)
                Text("Your selected apps are available until \(active.endDate.formatted(date: .omitted, time: .shortened)).")
                    .font(.subheadline)
                    .foregroundStyle(Color.Ember.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            // MARK: - Countdown
            CountdownView(endDate: active.endDate)
            
            // MARK: - Queued Sessions
            if unlockSessionManager.queueCount > 0 {
                Text("\(unlockSessionManager.queueCount) session\(unlockSessionManager.queueCount == 1 ? "" : "s") queued after this one")
                font(.caption)
                    .foregroundStyle(Color.Ember.textTertiary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.Ember.surfaceSubtle)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            // MARK: - End Session Button
            Button(action: {
                showCancelConfirmation = true
            }) {
                Text("End Session Early")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.Tier.boss.text)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.Tier.boss.subtle)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(32)
    }
}
