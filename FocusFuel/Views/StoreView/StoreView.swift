//
//  StoreView.swift
//  FocusFuelPlay
//
//  Created by Daniel Pressner on 24.03.2026.
//

import SwiftUI
import FamilyControls

struct StoreView: View {
    
    @State var viewModel: StoreViewModel
    
    var body: some View {
        Group {
            if viewModel.familyControlsManager.authorizationStatus == .approved {
                StoreContent(viewModel: $viewModel, fuelBalance: viewModel.fuelManager.balance)
            } else {
                FamilyControlsLockedView(familyControls: viewModel.familyControlsManager)
            }
        }
    }
}

struct StoreContent: View {
    
    @Binding var viewModel: StoreViewModel
    
    var fuelBalance: Int
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                FuelBadge(fuelBalance: fuelBalance, size: .regular)
                Spacer()
                BackpackButtonView(inventorySheetIsPresented: $viewModel.inventorySheetIsPresented, inventoryCount: viewModel.unlockSessionManager.inventory.count)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            Divider()
                .overlay(Color.Ember.borderSubtle)
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(SessionDuration.allCases) { duration in
                        SessionPurchaseCard(fuelBalance: fuelBalance, duration: duration) {
                            viewModel.handlePurchase(duration: duration)
                        }
                    }
                }
                .padding(16)
            }
        }
        .background(Color.Ember.appBackground)
        .sheet(isPresented: $viewModel.inventorySheetIsPresented) {
            BackPackView(viewModel: BackPackViewModel(unlockSessionManager: viewModel.unlockSessionManager, fuelManager: viewModel.fuelManager, familyControlsManager: viewModel.familyControlsManager))
        }
        .alert("Not Enough Fuel", isPresented: $viewModel.isPurchaseErrorPresented) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.purchaseErrorMessage)
        }
    }
}

struct SessionPurchaseCard: View {
    
    var fuelBalance: Int
    let duration: SessionDuration
    let onPurchase: () -> Void
    
    var canAfford: Bool {
        return fuelBalance >= duration.fuelCost
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
