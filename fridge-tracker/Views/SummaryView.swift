//
//  SummaryView.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/6/23.
//

import SwiftData
import SwiftUI

struct SummaryView: View {
    @Query private var items: [FridgeItem] // TODO: change this so that all views share one query

    var body: some View {
        TabView {
            #if DEBUG
            PieChartView().tabItem { Label("Chart", systemImage: "chart.pie") }
            #else
            PieChartView(items: items).tabItem { Label("Chart", systemImage: "chart.pie") }
            #endif

            #if DEBUG
            CalendarView().tabItem { Label("Calendar", systemImage: "calendar") }
            #else
            CalendarView(items: items).tabItem { Label("Calendar", systemImage: "calendar") }
            #endif
        }
        .tabViewStyle(.page)
    }
}

#Preview {
    SummaryView()
        .modelContainer(previewContainer)
}
