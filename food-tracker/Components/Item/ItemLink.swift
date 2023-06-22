//
//  ItemLink.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/6/23.
//

import SwiftUI

enum SwipeActions {
    case delete
    case archive
    case unarchive
}

struct ItemLink: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.editMode) private var listEditMode

    var item: FridgeItem

    let leadingActions: [SwipeActions]
    let trailingActions: [SwipeActions]

    private var showingEditingTools: Bool {
        return listEditMode?.wrappedValue.isEditing ?? false
    }

    init(item: FridgeItem, leadingActions: [SwipeActions] = [], trailingActions: [SwipeActions] = []) {
        self.item = item
        self.leadingActions = leadingActions
        self.trailingActions = trailingActions
    }

    var body: some View {
        NavigationLink {
            ItemDetail(item: item, adding: .constant(false))
        } label: {
            HStack(alignment: .center) {
                Image(uiImage: item.category.icon)

                Divider()

                VStack(alignment: .leading) {
                    Text(item.name).font(.headline)

                    HStack {
                        ItemDate(date: item.expiryDate)
                            .font(.footnote.monospaced())

                        Spacer()

                        ItemCategory(category: item.category).font(.footnote)
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .swipeActions(edge: .leading) {
            ForEach(leadingActions, id: \.self) {
                choice in chooseAction(action: choice)
            }
        }
        .swipeActions {
            ForEach(trailingActions, id: \.self) { choice in
                chooseAction(action: choice)
            }
        }
    }

    func deleteItem() {
        withAnimation {
            modelContext.delete(item) // TODO: this crashes https://developer.apple.com/documentation/xcode-release-notes/xcode-15-release-notes#SwiftData
        }
    }

    func toggleItemArchive() {
        withAnimation {
            item.archived.toggle()
        }
    }

    @ViewBuilder
    func chooseAction(action choice: SwipeActions) -> some View {
        switch choice {
        case .delete:
            SwipeDeleteButton(action: deleteItem)
        case .archive:
            SwipeArchiveButton(action: toggleItemArchive)
        case .unarchive:
            SwipeUnarchiveButton(action: toggleItemArchive)
        }
    }
}

#Preview("Item Link") {
    MainView()
        .modelContainer(previewContainer)
}
