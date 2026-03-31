//
//  StoreView.swift
//  FocusFuelPlay
//
//  Created by Daniel Pressner on 24.03.2026.
//

import SwiftUI
import FamilyControls

struct StoreView: View {
    
    @EnvironmentObject var fuelManager: FuelManager
    @EnvironmentObject var unlockSessionManager: UnlockSessionManager
    @EnvironmentObject var familyControlsManager: FamilyControlsManager
    
    @State private var inventorySheetIsPresented: Bool = false
    @State private var purchaseErrorMessage: String = ""
    @State private var isPurchaseErrorPresented: Bool = false
    
    var body: some View {
        Group {
            if familyControlsManager.authorizationStatus == .approved {
                storeContent
            } else {
                FamilyControlsLockedView()
            }
        }
    }
    
    // MARK: - Store Content
    
    private var storeContent: some View {
        VStack(spacing: 0) {
            
            // MARK: - Top Bar
            HStack {
                FuelBadge(fuelBalance: fuelManager.balance, size: .regular)
                Spacer()
                Button(action: {
                    inventorySheetIsPresented.toggle()
                }) {HStack {
                    Image(systemName: "backpack")
                        .font(.subheadline)
                    if UnlockSessionManager.shared.inventory.count > 0 {
                        Text("\(UnlockSessionManager.shared.inventory.count)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.Ember.textInverse)
                            .frame(minWidth: 16, minHeight: 16)
                            .background(Color.Ember.accentDefault)
                            .clipShape(Circle())
                    }
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
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            Divider()
                .overlay(Color.Ember.borderSubtle)
            
            // MARK: - Session Cards
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(SessionDuration.allCases) { duration in
                        SessionPurchaseCard(duration: duration) {
                            handlePurchase(duration: duration)
                        }
                    }
                }
                .padding(16)
            }
        }
        .background(Color.Ember.appBackground)
        .sheet(isPresented: $inventorySheetIsPresented) {
            BackPackView()
        }
        .alert("Not Enough Fuel", isPresented: $isPurchaseErrorPresented) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(purchaseErrorMessage)
        }
    }
    
    // MARK: - Purchase Handler
    
    private func handlePurchase(duration: SessionDuration) {
        let result: (success: Bool, message: String) = unlockSessionManager.purchase(
            duration: duration,
            fuelBalance: fuelManager.balance
        )
        if result.success {
            let didDeduct: Bool = fuelManager.deductFuel(amount: duration.fuelCost)
            if !didDeduct {
                purchaseErrorMessage = "Not enough Fuel for a \(duration.displayName) session."
                isPurchaseErrorPresented = true
            }
        } else {
            purchaseErrorMessage = result.message
            isPurchaseErrorPresented = true
        }
    }
}

// MARK: - Session Purchase Card

struct SessionPurchaseCard: View {
    
    @EnvironmentObject var fuelManager: FuelManager
    
    let duration: SessionDuration
    let onPurchase: () -> Void
    
    var canAfford: Bool {
        return fuelManager.balance >= duration.fuelCost
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(duration.displayName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.Ember.textPrimary)
                Text("Unlock all selected apps")
                    .font(.caption)
                    .foregroundStyle(Color.Ember.textSecondary)
            }
            Spacer()
            Button(action: onPurchase) {
                HStack(spacing: 4) {
                    Image(systemName: "bolt.circle")
                    Text("\(duration.fuelCost)")
                }
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(canAfford ? Color.Ember.textInverse : Color.Ember.textTertiary)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(canAfford ? Color.Ember.accentDefault : Color.Ember.surfaceSubtle)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .disabled(!canAfford)
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
