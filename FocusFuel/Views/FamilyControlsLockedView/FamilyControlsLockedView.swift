//
//  FamilyControlsLockedView.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 27.03.2026.
//

import SwiftUI

struct FamilyControlsLockedView: View {
    
    @Environment(FamilyControlsManager.self) var familyControlsManager
    @State private var viewModel: FamilyControlsLockedViewModel
    
    init(familyControls: FamilyControlsManager) {
        _viewModel = .init(initialValue: FamilyControlsLockedViewModel(familyControlsManager: familyControls))
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "lock.shield")
                .font(.system(size: 60))
                .foregroundStyle(Color.Ember.accentDefault)
            VStack(spacing: 8) {
                Text("Screen Time Access Required")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.Ember.textPrimary)
                Text("FocusFuel needs Screen Time permission to lock distracting apps and later unlock them as a reward for completing tasks.")
                    .font(.subheadline)
                    .foregroundStyle(Color.Ember.textSecondary)
                    .multilineTextAlignment(.center)
                Button(action: {
                    viewModel.requestFamilyControlsAuthorization()
                }) {
                    Text("Enable Screen Time Access")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.Ember.textInverse)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 14)
                        .background(Color.Ember.accentDefault)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                if viewModel.denied {
                    Text("If the dialog doesn't appear, go to Settings → Screen Time → FocusFuel to enable access.")
                        .font(.caption)
                        .foregroundStyle(Color.Ember.textTertiary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(32)
            .background(Color.Ember.appBackground)
        }
    }
}
