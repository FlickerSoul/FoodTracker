//
//  SummaryView.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/6/23.
//

import SwiftData
import SwiftUI

private enum SummaryTabs: Hashable {
    case pie
    case cal
}

struct SummaryView: View {
    @Query private var items: [FoodItem] // TODO: change this so that all views share one query

    @State private var selectedTab: SummaryTabs = .cal

    @State private var itemStack: [FoodItem] = []

    var body: some View {
        NavigationView {
            VStack {
                Picker("", selection: $selectedTab) {
                    Text("Calendar").tag(SummaryTabs.cal)
                    Text("Pie Chart").tag(SummaryTabs.pie)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                switch selectedTab {
                case .pie:
                    PieChartView(items: items).tabItem { Label("Chart", systemImage: "chart.pie").foregroundColor(.blue) }
                case .cal:
                    CalendarView(items: items).tabItem { Label("Calendar", systemImage: "calendar").foregroundColor(.blue) }
                }
            }
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        SummaryView()
            .modelContainer(previewContainer)
    }
}
