//
//  LockContentView.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 30.03.2026.
//

import SwiftUI

struct LockContentView: View {
    
    @Environment(UnlockSessionManager.self) var unlockSessionManager
    @Environment(FamilyControlsManager.self) var familyControlsManager: FamilyControlsManager
    @Environment(FuelManager.self) var fuelManager
    
    @Binding var inventorySheetIsPresented: Bool
    @Binding var showCancelConfirmation: Bool
    @Binding var isAppPickerSheetPresented: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - Top Bar
            HStack {
                FuelBadge(fuelBalance: fuelManager.balance, size: .regular)
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
                ActiveSessionView(showCancelConfirmation: $showCancelConfirmation, active: active)
            } else {
                NoUnlocksView()
            }
            
            Spacer()
        }
        .background(Color.Ember.appBackground)
        .sheet(isPresented: $inventorySheetIsPresented) {
            BackPackView(viewModel: BackPackViewModel(unlockSessionManager: unlockSessionManager, fuelManager: fuelManager, familyControlsManager: familyControlsManager))
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
}
