//
//  MainView.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/6/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem { Label("Items", systemImage: "square.and.pencil") }

            SummaryView()
                .tabItem { Label("Summary", systemImage: "info.square") }

            SettingsView()
                .tabItem { Label("Settings", systemImage: "slider.horizontal.3") }
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        MainView()
            .modelContainer(previewContainer)
    }
}
