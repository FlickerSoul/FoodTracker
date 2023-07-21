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
    case markTemplate
    case consume
    case putBack
}

struct ItemLink: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.editMode) private var listEditMode

    var item: FoodItem
    let viewingStyle: DetailViewingStyle

    let leadingActions: [SwipeActions]
    let trailingActions: [SwipeActions]
    let templateCreationStyle: TemplateCreationStyle?

    private var showingEditingTools: Bool {
        return listEditMode?.wrappedValue.isEditing ?? false
    }

    init(item: FoodItem, viewingStyle: DetailViewingStyle, leadingActions: [SwipeActions] = [], trailingActions: [SwipeActions] = []) {
        self.item = item
        self.viewingStyle = viewingStyle
        self.leadingActions = leadingActions
        self.trailingActions = trailingActions
        self.templateCreationStyle = nil
    }

    init(item: FoodItem, templateCreationStyle: TemplateCreationStyle, leadingActions: [SwipeActions] = [], trailingActions: [SwipeActions] = []) {
        self.item = item
        self.viewingStyle = .adding
        self.leadingActions = leadingActions
        self.trailingActions = trailingActions
        self.templateCreationStyle = templateCreationStyle
    }

    var body: some View {
        NavigationLink {
            if let templateCreationStyle = templateCreationStyle {
                ItemDetail(item: item.copy(by: templateCreationStyle), viewingStyling: .adding, showScannerWhenOpen: false)

            } else {
                ItemDetail(item: item, viewingStyling: viewingStyle, showScannerWhenOpen: false)
            }
        } label: {
            HStack(alignment: .center) {
                Image(uiImage: item.category.icon)

                Divider()

                VStack(alignment: .leading) {
                    Text(item.name).font(.headline)

                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            ItemDate(date: item.expiryDate)
                        }
                        HStack(alignment: .center) {
                            ItemConsumption(used: item.usedQuantity, total: item.quantity)

                            Spacer()

                            ItemCategory(category: item.category)
                        }
                    }
                    .font(.footnote)
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
        .contextMenu {
            if item.canConsume {
                chooseAction(action: .consume)
            }

            if item.canPutBack {
                chooseAction(action: .putBack)
            }

            Divider()

            if item.archived {
                chooseAction(action: .unarchive)
            } else {
                chooseAction(action: .archive)
            }

            Divider()

            chooseAction(action: .delete)
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

    func markTempalte() {
        item.isTemplate.toggle()
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
        case .markTemplate:
            SwipeMarkTemplateButton(action: markTempalte)
        case .consume:
            SwipeConsumeButton(action: item.consumeItem).disabled(!item.canConsume)
        case .putBack:
            SwipePutBackButton(action: item.putBackItem).disabled(!item.canPutBack)
        }
    }
}

#Preview("Item Link") {
    MainActor.assumeIsolated {
        MainView()
            .modelContainer(previewContainer)
    }
}
