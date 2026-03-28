//
//  AppLockView.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 28.03.2026.
//
import SwiftUI
import Combine
import FamilyControls

struct AppLockView: View {
    
    @EnvironmentObject var familyControlsManager: FamilyControlsManager
    @EnvironmentObject var unlockSessionManager: UnlockSessionManager
    @EnvironmentObject var fuelManager: FuelManager
    
    @State private var inventorySheetIsPresented: Bool = false
    @State private var showCancelConfirmation: Bool = false
    @State private var isAppPickerSheetPresented: Bool = false
    var body: some View {
        Group {
            if familyControlsManager.authorizationStatus == .approved {
                lockContent
            } else {
                FamilyControlsLockedView()
            }
        }
    }
    
    // MARK: - Lock Content
    
    private var lockContent: some View {
        VStack(spacing: 0) {
            
            // MARK: - Top Bar
            HStack {
                FuelBadge(size: .regular)
                Spacer()
                Button(action: {
                    inventorySheetIsPresented = true
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "backpack")
                            .font(.subheadline)
                        if unlockSessionManager.inventory.count > 0 {
                            Text("\(unlockSessionManager.inventory.count)")
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
                
                Button(action: {
                       isAppPickerSheetPresented = true
                   }) {
                       Image(systemName: "slider.horizontal.3")
                           .padding(.horizontal, 6.0)
                           .padding(.vertical, 4.0)
                   }
                   .buttonStyle(.bordered)
                   .tint(Color.Ember.accentDefault)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            Divider()
                .overlay(Color.Ember.borderSubtle)
            
            Spacer()
            
            // MARK: - Status Display
            if let active: ActiveSession = unlockSessionManager.activeSession {
                activeSessionView(active: active)
            } else {
                lockedView
            }
            
            Spacer()
        }
        .background(Color.Ember.appBackground)
        .sheet(isPresented: $inventorySheetIsPresented) {
            BackPackView()
        }
        .sheet(isPresented: $isAppPickerSheetPresented) {
            AppPickerView()
        }
        .confirmationDialog(
            "End Session Early?",
            isPresented: $showCancelConfirmation,
            titleVisibility: .visible
        ) {
            Button("End Session", role: .destructive) {
                let refund: Int = unlockSessionManager.cancelActiveSession(
                    familyControlsManager: familyControlsManager
                )
                fuelManager.refundFuel(amount: refund)
            }
            Button("Keep Session", role: .cancel) {}
        } message: {
            if let active: ActiveSession = unlockSessionManager.activeSession {
                Text("You'll receive \(active.refundAmount) Fuel back. This cannot be undone.")
            }
        }
    }
    
    // MARK: - Locked View
    
    private var lockedView: some View {
        VStack(spacing: 24) {
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 70))
                .foregroundStyle(Color.Tier.boss.default)
            
            VStack(spacing: 8) {
                Text("Apps Locked")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.Ember.textPrimary)
                Text("Complete tasks to earn Fuel, then spend it in the store to unlock your apps.")
                    .font(.subheadline)
                    .foregroundStyle(Color.Ember.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            if !familyControlsManager.hasSelectedApps {
                noAppsSelectedWarning
            }
        }
        .padding(32)
    }
    
    // MARK: - Active Session View
    
    private func activeSessionView(active: ActiveSession) -> some View {
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
    
    // MARK: - No Apps Selected Warning
    
    private var noAppsSelectedWarning: some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle")
                .foregroundStyle(Color.Tier.medium.default)
            Text("No apps selected to lock. Add apps in Settings.")
                .font(.caption)
                .foregroundStyle(Color.Ember.textSecondary)
        }
        .padding(12)
        .background(Color.Tier.medium.subtle)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.Tier.medium.default.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Countdown View

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
