//
//  StoreView.swift
//  FocusFuelPlay
//
//  Created by Daniel Pressner on 24.03.2026.
//

import SwiftUI

struct StoreView: View {
    
    @State var inventorySheetIsPresented = false
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Text("35")
                    Image(systemName: "bolt.circle")
                }
                .padding(.horizontal, 6.0)
                .padding(.vertical, 4.0)
                Spacer()
                Button(action: { inventorySheetIsPresented.toggle()}) {
                    Image(systemName: "backpack")
                        .padding(.horizontal, 6.0)
                        .padding(.vertical, 4.0)
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal, 16)
            VStack {
                Text("30 minute, single app unlock")
                Text("15 minute, sincle app unlock")
                Text("60 minute, single app unlock")
                Text("30 minute, all apps unlock")
                Text("15 minute, all apps unlock")
                Text("60 minute, all apps unlock")
                Text("60 minute external unlock timer")
                Text("120 minute external unlock timer")
            }
        }
        .sheet(isPresented: $inventorySheetIsPresented) {
            Text("Inventory Items")
        }
    }
}

#Preview {
    StoreView()
}
