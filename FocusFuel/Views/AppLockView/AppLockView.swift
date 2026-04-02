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
    
    @Environment(FamilyControlsManager.self) var familyControlsManager
    @Environment(UnlockSessionManager.self) var unlockSessionManager
    @Environment(FuelManager.self) var fuelManager
    
    @State private var inventorySheetIsPresented: Bool = false
    @State private var showCancelConfirmation: Bool = false
    @State private var isAppPickerSheetPresented: Bool = false
    
    var body: some View {
        Group {
            if familyControlsManager.authorizationStatus == .approved {
                LockContentView(inventorySheetIsPresented: $inventorySheetIsPresented, showCancelConfirmation: $showCancelConfirmation, isAppPickerSheetPresented: $isAppPickerSheetPresented)
            } else {
                FamilyControlsLockedView(familyControls: familyControlsManager)
            }
        }
    }
    
    // MARK: - Lock Content
    
   
}


