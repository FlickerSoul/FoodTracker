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
                Text(date, style: .date).foregroundStyle(date < Date.now ? Color(.red) : Color(.green))
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

struct ItemLink: View {
    var item: FridgeItem

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(item.name).font(.title2)

                ItemDate(name: "Expire", date: item.expiryDate, color: true)

                ItemDate(name: "Added", date: item.expiryDate)
            }

            Spacer()

            Image(systemName: "chevron.right")
        }
    }
}

#Preview("Item Link") {
    MainView()
        .modelContainer(previewContainer)
}
