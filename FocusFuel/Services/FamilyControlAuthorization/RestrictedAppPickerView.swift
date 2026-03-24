//
//  RestrictedAppPickerView.swift
//  FocusFuelPlay
//
//  Created by Daniel Pressner on 22.03.2026.
//

import SwiftUI
import FamilyControls

struct RestrictedAppPickerView: View {
    
    @State var pickerIsPresented = false
    @Binding var appSelections: FamilyActivitySelection
    
    var body: some View {
        
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .familyActivityPicker(isPresented: $pickerIsPresented, selection: $appSelections)
    }
}

#Preview {
    RestrictedAppPickerView(appSelections: .constant(.init()))
}
