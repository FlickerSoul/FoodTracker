//
//  ContentViewInnerView.swift
//  food-tracker
//
//  Created by Heyuan Zeng on 7/23/23.
//

import SwiftData
import SwiftUI

struct ContentViewInnerView: View {
    @State private var hiddenItemListOpen: Bool = false
    @State private var templatedItemListOpen: Bool = false

    @Query var visibleItems: [FoodItem]
    @Query var hiddenItems: [FoodItem]
    @Query var templatedItems: [FoodItem]

    var noHiddenItems: Bool {
        return hiddenItems.isEmpty
    }

    var noTemplatedItems: Bool {
        return templatedItems.isEmpty
    }

    var body: some View {
        List {
            Section {
                if visibleItems.count == 0 {
                    NoItemPrompt()
                } else {
                    ForEach(visibleItems, id: \.id) { item in
                        ItemLink(
                            item: item,
                            viewingStyle: .viewing,
                            leadingActions: [
                                .consume,
                                .archive,
                                .markTemplate
                            ],
                            trailingActions: [
                                .putBack,
                                .delete
                            ]
                        )
                    }
                }
            }

            Section {
                ItemLinkDropdown(name: "archived items", icon: "archivebox.circle", open: $hiddenItemListOpen)
                    .opacity(noHiddenItems ? 0.3 : 1)
                    .disabled(noHiddenItems)

                if hiddenItemListOpen {
                    if hiddenItems.count == 0 {
                        NoItemPrompt()
                    } else {
                        ForEach(hiddenItems, id: \.id) {
                            item in
                            ItemLink(
                                item: item,
                                viewingStyle: .viewing,
                                leadingActions: [.unarchive, .markTemplate],
                                trailingActions: [.delete]
                            )
                        }
                    }
                }
            }

            Section {
                ItemLinkDropdown(name: "Item Templates", icon: "books.vertical.circle", open: $templatedItemListOpen)
                    .opacity(noTemplatedItems ? 0.3 : 1)
                    .disabled(noTemplatedItems)

                if templatedItemListOpen {
                    if templatedItems.count == 0 {
                        NoItemPrompt()
                    } else {
                        ForEach(templatedItems) { item in
                            ItemLink(
                                item: item, viewingStyle: .viewing,
                                leadingActions: [.unarchive, .markTemplate],
                                trailingActions: [.delete]
                            )
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentViewInnerView()
}
