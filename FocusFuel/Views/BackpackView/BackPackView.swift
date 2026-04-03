//
//  BackPackView.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 28.03.2026.
//

import SwiftUI

struct BackPackView: View {
    
    @State var viewModel: BackPackViewModel
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.displayEmptyState {
                    BackPackViewEmptyState()
                } else {
                    InventoryContent(viewModel: $viewModel)
                }
            }
            .navigationTitle("Backpack")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(Color.Ember.accentDefault)
                }
            }
            .background(Color.Ember.appBackground)
        }
    }
}

struct InventoryContent: View {
    
    @Binding var viewModel: BackPackViewModel
    @Environment(FamilyControlsManager.self) var familyControlsManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // MARK: - Active Session
                if let active = viewModel.activeSession {
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader(title: "Active Session")
                        ActiveSessionCard(viewModel: $viewModel, active: active)
                    }
                }
                
                // MARK: - Queued Sessions
                if !viewModel.queue.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader(title: "Up Next")
                        ForEach(viewModel.queue) { session in
                            QueuedSessionCard(viewModel: $viewModel, session: session)
                        }
                    }
                }
                
                // MARK: - Available Sessions
                if !viewModel.inventory.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader(title: "Available")
                        ForEach(viewModel.inventory) { session in
                            InventorySessionCard(viewModel: $viewModel, session: session) {
                                viewModel.activate(session: session, familyControlsManager: familyControlsManager)
                            }
                        }
                    }
                }
            }
            .padding(16)
        }
        .background(Color.Ember.appBackground)
    }
}

struct BackPackViewEmptyState: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "backpack")
                .font(.system(size: 50))
                .foregroundStyle(Color.Ember.textTertiary)
            Text("Your backpack is empty")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(Color.Ember.textPrimary)
            Text("Purchase unlock sessions from the store to add them here.")
                .font(.subheadline)
                .foregroundStyle(Color.Ember.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.Ember.appBackground)
        .padding(32)
    }
}

struct SectionHeader: View {
    
    let title: String
    
    var body: some View {
        Text(title)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(Color.Ember.textTertiary)
            .textCase(.uppercase)
            .tracking(0.8)
    }
}

struct ActiveSessionCard: View {
    
    @Binding var viewModel: BackPackViewModel
    
    let active: ActiveSession
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(active.duration.displayName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.Ember.textPrimary)
                    Text("Apps unlocked until \(active.endDate.formatted(date: .omitted, time: .shortened))")
                        .font(.caption)
                        .foregroundStyle(Color.Ember.textSecondary)
                }
                Spacer()
                Image(systemName: "lock.open.fill")
                    .foregroundStyle(Color.Tier.quick.default)
                    .font(.title3)
            }
            
            Divider()
                .overlay(Color.Ember.borderSubtle)
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Refund if cancelled now")
                        .font(.caption)
                        .foregroundStyle(Color.Ember.textTertiary)
                    HStack(spacing: 4) {
                        Image(systemName: "bolt.circle")
                            .foregroundStyle(Color.Ember.accentDefault)
                        Text("\(active.refundAmount) Fuel")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(Color.Ember.accentText)
                    }
                }
                Spacer()
                Button(action: {
                    let refund: Int = viewModel.cancelActiveSession()
                    viewModel.refundFuel(amount: refund)
                }) {
                    Text("End Session")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.Tier.boss.text)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.Tier.boss.subtle)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding(16)
        .background(Color.Ember.surface)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.Tier.quick.default.opacity(0.4), lineWidth: 1.5)
        )
    }
}

// MARK: - Queued Session Card

struct QueuedSessionCard: View {
    
    @Binding var viewModel: BackPackViewModel
    let session: QueuedSession
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(session.duration.displayName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.Ember.textPrimary)
                Text("Queued — starts after current session ends")
                    .font(.caption)
                    .foregroundStyle(Color.Ember.textSecondary)
            }
            Spacer()
            Image(systemName: "clock")
                .foregroundStyle(Color.Tier.medium.default)
        }
        .padding(16)
        .background(Color.Ember.surface)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.Tier.medium.default.opacity(0.4), lineWidth: 1.5)
        )
    }
}

// MARK: - Inventory Session Card

struct InventorySessionCard: View {
    
    @Binding var viewModel: BackPackViewModel
    
    let session: UnlockSession
    let onActivate: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(session.duration.displayName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.Ember.textPrimary)
                Text("Purchased \(session.purchasedAt.formatted(date: .abbreviated, time: .omitted))")
                    .font(.caption)
                    .foregroundStyle(Color.Ember.textTertiary)
            }
            Spacer()
            Button(action: onActivate) {
                Text(viewModel.unlockSessionManager.hasActiveSession ? "Queue" : "Activate")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.Ember.textInverse)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.Ember.accentDefault)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(16)
        .background(Color.Ember.surface)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.Ember.borderSubtle, lineWidth: 1)
        )
    }
}
