//
//  ContentView.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/6/23.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var itemStack: [FridgeItem] = []
    @State private var addingItem: Bool = false
    @State private var orderSelection: OrderStyle = .expiringNearstFirst

    @State private var hiddenItemListOpen: Bool = false

    var items: [FridgeItem]

    var visibleItems: [FridgeItem] {
        return items.filter { !$0.archived }.sorted(by: orderSelection.comparator)
    }

    var hiddenItems: [FridgeItem] {
        return items.filter { !visibleItems.contains($0) }.sorted(by: orderSelection.comparator)
    }

    var body: some View {
        NavigationStack(path: $itemStack) {
            List {
                Section {
                    ForEach(visibleItems, id: \.id) { item in
                        ItemLink(
                            item: item,
                            leadingActions: [.archive],
                            trailingActions: [.delete]
                        ).onTapGesture {
                            withAnimation {
                                itemStack.append(item)
                            }
                        }
                    }
                }

                if hiddenItems.count > 0 {
                    Section {
                        ItemLinkDropdown(name: "archived items", icon: "archivebox.circle", open: $hiddenItemListOpen)

                        if hiddenItemListOpen {
                            ForEach(hiddenItems) {
                                item in
                                ItemLink(
                                    item: item,
                                    leadingActions: [.unarchive],
                                    trailingActions: [.delete]
                                ).onTapGesture {
                                    withAnimation {
                                        itemStack.append(item)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Items")
            .navigationDestination(for: FridgeItem.self) { item in
                ItemDetail(item: item, adding: $addingItem) {
                    addingItem = false
                    itemStack.removeLast()
                }
            }
            .toolbar {
                ToolbarItemGroup {
                    ItemSorter(selection: $orderSelection)

                    Button {
                        withAnimation {
                            addingItem = true
                            itemStack.append(FridgeItem.makeDefaultFridgeItem())
                        }
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
        }
    }
}

#Preview("preview items") {
    MainView().modelContainer(previewContainer)
}

#Preview("content view only") {
    NavigationView {
        ContentView(items: [])
    }.modelContainer(previewContainer)
}
