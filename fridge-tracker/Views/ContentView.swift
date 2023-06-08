//
//  ContentView.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/6/23.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var itemStack: [FridgeItem] = []
    @State private var addingItem: Bool = false

    @State private var hiddenItemListOpen: Bool = false

    @State private var listEditSelections: Set<UUID> = Set()

    @State private var orderSelection: OrderStyle = .expiringNearstFirst
    @State private var filteringExpired: Bool = false

    @Query private var items: [FridgeItem]

    var visibleItems: [FridgeItem] {
        var visibles = items.filter { !$0.archived }.sorted(by: orderSelection.comparator)

        if filteringExpired {
            visibles = visibles.filter(FridgeItem.isExpiring)
        }

        return visibles
    }

    var hiddenItems: [FridgeItem] {
        var hiddens = items.filter { !visibleItems.contains($0) }.sorted(by: orderSelection.comparator)
        if filteringExpired {
            hiddens = hiddens.filter(FridgeItem.isExpiring)
        }

        return hiddens
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
                            leadingActions: [.archive],
                            trailingActions: [.delete],
                            onTap: enterItem
                        )
                    }
                }

                if hiddenItems.count > 0 {
                    Section {
                        ItemLinkDropdown(name: "archived items", icon: "archivebox.circle", open: $hiddenItemListOpen)

                        if hiddenItemListOpen {
                            ForEach(hiddenItems, id: \.id) {
                                item in
                                ItemLink(
                                    item: item,
                                    leadingActions: [.unarchive],
                                    trailingActions: [.delete],
                                    onTap: enterItem
                                )
                            }
                        }
                    }
                }
            }
            .navigationTitle("Items")
            .navigationDestination(for: FridgeItem.self) { item in
                ItemDetail(item: item, adding: addingItem)
            }
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button(action: enterNewItem, label: {
                        Label("Add", systemImage: "plus")
                    })
                }

                ToolbarItemGroup(placement: .topBarLeading) {
                    ItemSorter(selection: $orderSelection)
                    ItemFilter(filtering: $filteringExpired)
                }
            }
        }
    }

    private func enterNewItem() {
        enterItem(item: FridgeItem.makeDefaultFridgeItem())
    }

    private func enterItem(item: FridgeItem) {
        addingItem = false
        withAnimation {
            itemStack.append(item)
        }
    }
}

#Preview("content view only") {
    MainView()
        .modelContainer(previewContainer)
}
