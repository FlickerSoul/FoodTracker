//
//  MainView.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/6/23.
//

import SwiftUI

private enum MainViewTabs: Hashable {
    case items
    case summary
    case settings
}

struct MainView: View {
    @State private var tabViewSelection: MainViewTabs = .items

    var body: some View {
        TabView(selection: $tabViewSelection) {
            ContentView()
                .tabItem { Label("Items", systemImage: "square.and.pencil") }
                .tag(MainViewTabs.items)

            SummaryView()
                .tabItem { Label("Summary", systemImage: "info.square") }
                .tag(MainViewTabs.summary)

            SettingsView()
                .tabItem { Label("Settings", systemImage: "slider.horizontal.3") }
                .tag(MainViewTabs.settings)
        }
        .onOpenURL { url in
            guard let components = getURLComponents(for: url, of: FOOD_TRACKER_URL_SCHEME), let action = getURLAction(for: components) else { return }

            switch action {
            case .viewItem:
                switchTab(to: .items)
            }
        }
    }

    private func switchTab(to tab: MainViewTabs) {
        withAnimation {
            tabViewSelection = tab
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        MainView()
            .modelContainer(previewContainer)
    }
}
