//
//  FamilControlsLockedViewModel.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 01.04.2026.
//

import Foundation
import SwiftUI
import FamilyControls

@Observable
class FamilyControlsLockedViewModel {
    
    var familyControlsManager: FamilyControlsManager
    
    init(familyControlsManager: FamilyControlsManager) {
        self.familyControlsManager = familyControlsManager
    }
    
    var denied: Bool {
        familyControlsManager.authorizationStatus == .denied
    }
    
    func requestFamilyControlsAuthorization() {
        familyControlsManager.requestAuthorization()
    }
}
