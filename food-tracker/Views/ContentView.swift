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

    @State private var hiddenItemListOpen: Bool = false

    @State private var listEditSelections: Set<UUID> = Set()

    @State private var orderSelection: OrderStyle = .expiringNearstFirst
    @State private var filteringExpired: ExpiringFilterStyle = .none

    @Query private var items: [FridgeItem]

    var visibleItems: [FridgeItem] {
        var visibles = items.filter { !$0.archived }.sorted(by: orderSelection.comparator)

        visibles = visibles.filter(filteringExpired.filter)

        return visibles
    }

    var hiddenItems: [FridgeItem] {
        var hiddens = items.filter { !visibleItems.contains($0) }.sorted(by: orderSelection.comparator)

        hiddens = hiddens.filter(filteringExpired.filter)

        return hiddens
    }

    var hasHiddenItems: Bool {
        return hiddenItems.count > 0
    }

    var body: some View {
        NavigationStack(path: $itemStack) {
            List {
                Section {
                    if visibleItems.count == 0 {
                        NoItemPrompt()
                    }

                    ForEach(visibleItems, id: \.id) { item in
                        ItemLink(
                            item: item,
                            viewingStyle: .editing,
                            leadingActions: [.archive],
                            trailingActions: [.delete]
                        )
                    }
                }

                Section {
                    ItemLinkDropdown(name: "archived items", icon: "archivebox.circle", open: $hiddenItemListOpen)
                        .opacity(hasHiddenItems ? 1 : 0.3)
                        .disabled(!hasHiddenItems)

                    if hiddenItemListOpen {
                        ForEach(hiddenItems, id: \.id) {
                            item in
                            ItemLink(
                                item: item, viewingStyle: .editing,
                                leadingActions: [.unarchive],
                                trailingActions: [.delete]
                            )
                        }
                    }
                }
            }
            .navigationTitle("Items")
            .navigationDestination(for: ItemDetailInfo.self) { info in
                ItemDetail(item: info.item, viewingStyling: info.viewingStyle)
            }
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button {} label: {
                        Label("Add By Scanning", systemImage: "barcode.viewfinder")
                    }
                    Button(action: enterNewItem, label: {
                        Label("Add", systemImage: "plus")
                    })
                }

                ToolbarItemGroup(placement: .topBarLeading) {
                    ItemSorter(selection: $orderSelection)
                    ItemFilter(filtering: $filteringExpired, text: "Filter Expired")
                }
            }
        }
    }

    private func enterNewItem() {
        enterItem(item: FridgeItem.makeDefaultFridgeItem(), viewingStyle: .adding)
    }

    private func enterEditItem(item: FridgeItem) {
        enterItem(item: item, viewingStyle: .editing)
    }

    private func enterItem(item: FridgeItem, viewingStyle: DetailViewingStyle) {
        withAnimation {
            itemStack.append(.init(item: item, viewingStyle: viewingStyle))
        }
    }
}

#Preview("content view only") {
    MainActor.assumeIsolated {
        MainView()
            .modelContainer(previewContainer)
    }
}
