//
//  noUnlocksView.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 30.03.2026.
//

import SwiftUI

struct NoUnlocksView: View {

    @Environment(FamilyControlsManager.self) var familyControlsManager
    
var body: some View {
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

