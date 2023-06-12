//
//  ItemLink.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/6/23.
//

import SwiftUI

// MARK: Date View

struct ItemDate: View {
    let name: String
    let date: Date
    var color: Bool = false

    var displayName: String {
        return "\(name):"
    }

    var body: some View {
        HStack(spacing: 5) {
            Text(displayName)
            if color {
                Text(date, style: .date).foregroundStyle(date < Date.now ? .red : .green)
            } else {
                Text(date, style: .date)
            }
        }
    }
}

#Preview("Color Item Date") {
    ItemDate(name: "Expiry Date", date: Date.now + 24 * 3600)
}

#Preview("Color Item Date") {
    ItemDate(name: "Expiry Date", date: Date.now + 24 * 3600, color: true)
}

#Preview("Color Item Date Old") {
    ItemDate(name: "Expiry Date", date: Date.now - 3600, color: true)
}

// MARK: Link View

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

    let onTap: (FridgeItem) -> Void

    private var showingEditingTools: Bool {
        return listEditMode?.wrappedValue.isEditing ?? false
    }

    init(item: FridgeItem, leadingActions: [SwipeActions] = [], trailingActions: [SwipeActions] = [], onTap action: @escaping (FridgeItem) -> Void) {
        self.item = item
        self.leadingActions = leadingActions
        self.trailingActions = trailingActions
        self.onTap = action
    }

    var body: some View {
        NavigationLink {
            ItemDetail(item: item, adding: .constant(false))
        } label: {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(item.name).font(.title2)

                    ItemDate(name: "Expire", date: item.expiryDate, color: true)

                    ItemDate(name: "Added", date: item.addedDate)
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
