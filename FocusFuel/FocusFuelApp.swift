//
//  FocusFuelApp.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 13.03.2026.
//

import SwiftUI
import SwiftData

@main
struct FocusFuelApp: App {

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            ContentView()
              //  .environment(authorizationModel)
        }
        .modelContainer(for: [FuelBalance.self, FuelTask.self])
    }
}
