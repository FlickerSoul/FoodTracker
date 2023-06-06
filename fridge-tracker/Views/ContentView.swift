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
    var items: [FridgeItem]
    @State private var itemStack: [FridgeItem] = []
    @State private var addingItem: Bool = false

    var body: some View {
        NavigationStack(path: $itemStack) {
            List {
                ForEach(items, id: \.id) { item in
                    ItemLink(item: item)
                        .onTapGesture {
                            withAnimation {
                                itemStack.append(item)
                            }
                        }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Items")
            .navigationDestination(for: FridgeItem.self) { item in
                ItemDetail(item: item, adding: addingItem)
            }
            .toolbar {
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

    private func addItem() {
        withAnimation {
            let newItem = FridgeItem.makeDefaultFridgeItem()
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    MainView()
        .modelContainer(previewContainer)
}
