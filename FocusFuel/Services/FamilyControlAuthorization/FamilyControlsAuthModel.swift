//
//  AuthorizationModel.swift
//  FocusFuelPlay
//
//  Created by Daniel Pressner on 22.03.2026.
//

import Foundation
import Observation
import FamilyControls

@Observable
class AppControlsAuthorizationModel {
    
    var authorizationStatus: FamilyControls.AuthorizationStatus = .notDetermined
    
    init() {
        authorizationStatus = AuthorizationCenter.shared.authorizationStatus
    }
    
    func requestAuthorization() async {
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            authorizationStatus = AuthorizationCenter.shared.authorizationStatus
        } catch let error {
            print("Authorization failed: \(error.localizedDescription)")
            authorizationStatus = AuthorizationCenter.shared.authorizationStatus
        }
    }
}
