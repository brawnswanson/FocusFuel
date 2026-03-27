//
//  AppStatusView.swift
//  FocusFuelPlay
//
//  Created by Daniel Pressner on 24.03.2026.
//

import SwiftUI
import FamilyControls

struct AppPickerView: View {
    
    @EnvironmentObject var familyControlsManager: FamilyControlsManager
    @State private var isPickerPresented: Bool = false
    
    var body: some View {
        Group {
            if familyControlsManager.authorizationStatus == .approved {
                VStack(spacing: 20) {
                    VStack(spacing: 9) {
                        Text("Apps to Block")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.Ember.textPrimary)
                        Text("Choose which apps FocusFuel can lock when you haven't earned screen time.")
                            .font(.subheadline)
                            .foregroundStyle(Color.Ember.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    if familyControlsManager.hasSelectedApps {
                        let count = familyControlsManager.activitySelection.applicationTokens.count
                        Text("\(count) app\(count == 1 ? "" : "s") selected")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(Color.Ember.accentDefault)
                    } else {
                        Text("No apps selected yet")
                            .font(.subheadline)
                            .foregroundStyle(Color.Ember.textSecondary)
                    }
                    Button(action: { isPickerPresented = true}) {
                        Text(familyControlsManager.hasSelectedApps ? "Change Selected Apps" : "Select Apps")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 14)
                            .background(Color.Ember.accentDefault)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding(32)
                .background(Color.Ember.appBackground)
                .familyActivityPicker(
                    isPresented: $isPickerPresented,
                    selection: $familyControlsManager.activitySelection
                )
                .onChange(of: familyControlsManager.activitySelection) { familyControlsManager.saveSelection() }
            } else {
                FamilyControlsLockedView()
            }
        }
        
    }
}
