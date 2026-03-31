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
                LockContentView(inventorySheetIsPresented: $inventorySheetIsPresented, showCancelConfirmation: $showCancelConfirmation, isAppPickerSheetPresented: $isAppPickerSheetPresented)
            } else {
                FamilyControlsLockedView()
            }
        }
    }
    
    // MARK: - Lock Content
    
   
}


