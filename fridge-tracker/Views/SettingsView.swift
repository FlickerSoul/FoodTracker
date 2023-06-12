//
//  SettingsView.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/6/23.
//

import SwiftUI

struct SettingsView: View {
    @State private var settings: SettingsConfig = .init()

    var body: some View {
        NavigationView {
            List {
                Section {
                    AboutLink()
                }
            }
            .navigationTitle("Settings")
            .onChange(of: settings) { _, newValue in
                newValue.store()
            }
        }
    }
}

#Preview {
    SettingsView()
}
