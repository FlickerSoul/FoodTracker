//
//  SettingsView.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/6/23.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                AboutLink()
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
