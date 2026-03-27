//
//  ContentView.swift
//  FocusFuel
//
//  Created by Daniel Pressner on 13.03.2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var context
    @Query var fuelBalance: [FuelBalance]
    
    //  @Environment(AppControlsAuthorizationModel.self) private var authorizationModel
    
    var body: some View {
        Group {
            TabView {
                Tab("", systemImage: "checklist") {
                    TaskListView()
                }
                
                Tab("", systemImage: "lock.badge.clock") {
                    AppStatusView()
                }
                Tab("", systemImage: "basket") {
                    StoreView()
                }
            }
            .onAppear {
                if fuelBalance.isEmpty {
                    let newFuelBalance = FuelBalance()
                    context.insert(newFuelBalance)
                    try? context.save()
                }
            }
            
            /*  .task {
             if authorizationModel.authorizationStatus != .approved {
             await authorizationModel.requestAuthorization()
             }
             } */
            
        }
    }
}
// MARK: - Preview

#Preview {
    ContentView()
        .modelContainer(for: [FuelTask.self, FuelBalance.self], inMemory: true)
}
