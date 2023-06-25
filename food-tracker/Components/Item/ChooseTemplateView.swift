//
//  ChooseTemplateView.swift
//  food-tracker
//
//  Created by Heyuan Zeng on 6/25/23.
//

import SwiftData
import SwiftUI

private let TEMPLATE_PREDICATE = #Predicate<FridgeItem> { item in
    item.isTemplate
}

enum TemplateCreationStyle {
    case sameExpiryDate
    case samePeriodOfTime
}

struct ChooseTemplateView: View {
    @Query(filter: TEMPLATE_PREDICATE, sort: \.addedDate) var templatedItems: [FridgeItem]

    @State private var sortStyle: OrderStyle = .oldestAddedFirst

    let templateCreationStyle: TemplateCreationStyle

    var displayedItems: [FridgeItem] {
        templatedItems.sorted(by: sortStyle.comparator)
    }

    var body: some View {
        if displayedItems.isEmpty {
            VStack {
                Text("No Templates Found")
            }
        } else {
            List {
                ForEach(displayedItems) { item in
                    ItemLink(item: item, templateCreationStyle: templateCreationStyle)
                }
            }
            .toolbar {
                ItemSorter(selection: $sortStyle)
            }
        }
    }
}

#Preview("same expiry date") {
    MainActor.assumeIsolated {
        NavigationView {
            ChooseTemplateView(templateCreationStyle: .sameExpiryDate)
                .modelContainer(previewContainer)
        }
    }
}

#Preview("same period of time") {
    MainActor.assumeIsolated {
        NavigationView {
            ChooseTemplateView(templateCreationStyle: .samePeriodOfTime)
                .modelContainer(previewContainer)
        }
    }
}
