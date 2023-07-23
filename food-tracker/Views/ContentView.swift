//
//  ContentView.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/6/23.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var itemStack: [ItemDetailInfo] = []
    @State private var addingItem: Bool = false

    @State private var listEditSelections: Set<UUID> = Set()

    @State private var orderSelection: OrderStyle = .expiringNearstFirst
    @State private var filteringExpired: ExpiringFilterStyle = .none

    @State private var chooseFromTemplateSheetOpen: Bool = false

    private var visibleItems: Query<FoodItem, [FoodItem]> {
        return Query(
            FetchDescriptor(
                predicate: #Predicate { !$0._archived },
                sortBy: [orderSelection.sortDescriptor]
            )
        )
    }

    private var hiddenItems: Query<FoodItem, [FoodItem]> {
        return Query(
            FetchDescriptor(
                predicate: #Predicate { $0._archived },
                sortBy: [orderSelection.sortDescriptor]
            )
        )
    }

    private var templateItems: Query<FoodItem, [FoodItem]> {
        return Query(
            FetchDescriptor(
                predicate: #Predicate { $0.isTemplate },
                sortBy: [orderSelection.sortDescriptor]
            )
        )
    }

    var body: some View {
        NavigationStack(path: $itemStack) {
            ContentViewInnerView(
                visibleItems: visibleItems,
                hiddenItems: hiddenItems,
                templatedItems: templateItems
            )
            .navigationTitle("Items")
            .navigationDestination(for: ItemDetailInfo.self) { info in
                ItemDetail(item: info.item, viewingStyling: info.viewingStyle, showScannerWhenOpen: info.showScannerWhenOpen)
            }
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        chooseFromTemplateSheetOpen.toggle()
                    }
                    label: {
                        Label("Add Using Tempaltes", systemImage: "book.pages")
                    }

                    Button(action: enterNewItemAndScan) {
                        Label("Add By Scanning", systemImage: "barcode.viewfinder")
                    }

                    Button(action: enterNewItem) {
                        Label("Add", systemImage: "plus")
                    }
                }

                ToolbarItemGroup(placement: .topBarLeading) {
                    ItemSorter(selection: $orderSelection)
                    ItemFilter(filtering: $filteringExpired, text: "Filter Expired")
                }
            }
        }
        .sheet(isPresented: $chooseFromTemplateSheetOpen) {
            ChooseTemplateAction()
        }
        .onOpenURL { url in
            guard let components = getURLComponents(for: url, of: FOOD_TRACKER_URL_SCHEME), let action = getURLAction(for: components) else { return }

            // TODO: log errors
            switch action {
            case .viewItem:
                guard let itemIdQuery = components.queryItems?.first else {
                    return
                }

                // TODO: encap this into a fn
                guard itemIdQuery.name == "id", let id = itemIdQuery.value else {
                    return
                }

                guard let item = fetchFoodItem(for: id) else { return }

                addItem(item: item, viewingStyle: .viewing, showScannerWhenOpen: false)
            }
        }
    }

    private func enterNewItem() {
        addItem(item: FoodItem.makeDefaultFoodItem(), viewingStyle: .adding)
    }

    private func enterNewItemAndScan() {
        addItem(item: FoodItem.makeDefaultFoodItem(), viewingStyle: .adding, showScannerWhenOpen: true)
    }

    private func addItem(item: FoodItem, viewingStyle: DetailViewingStyle, showScannerWhenOpen: Bool = false) {
        withAnimation {
            itemStack.append(.init(item: item, viewingStyle: viewingStyle, showScannerWhenOpen: showScannerWhenOpen))
        }
    }
}

#Preview("content view only") {
    MainActor.assumeIsolated {
        ContentView()
            .modelContainer(previewContainer)
    }
}
