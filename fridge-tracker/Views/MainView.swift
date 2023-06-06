//
//  MainView.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/6/23.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Query private var items: [FridgeItem]
    
    var body: some View {
        TabView {
            ContentView(items: items)
                .tabItem { Label("Items", systemImage: "square.and.pencil") }
            
            SummaryView()
                .tabItem { Label("Summary", systemImage: "info.square") }
            
            SettingsView()
                .tabItem { Label("Settings", systemImage: "slider.horizontal.3") }
        }
    }
}

#Preview {
    MainView()
        .modelContainer(previewContainer)
}
