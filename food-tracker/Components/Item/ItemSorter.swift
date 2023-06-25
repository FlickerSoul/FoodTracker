//
//  ItemFilter.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/7/23.
//

import SwiftUI

enum OrderStyle: String, CaseIterable, Identifiable {
    typealias ComparatorType = (FridgeItem, FridgeItem) -> Bool

    case expiringNearstFirst = "expiring first"
    case expiringFarestFirst = "expiring farest first"
    case newestAddedFirst = "newest added first"
    case oldestAddedFirst = "oldest added first"
    case aToz = "A to Z"
    case zToa = "Z to A"

    var id: String {
        return self.rawValue
    }

    var comparator: ComparatorType {
        switch self {
        case .expiringNearstFirst:
            return Self.sortExpiringNearestFirst
        case .expiringFarestFirst:
            return Self.sortExpiringFarestFirst
        case .newestAddedFirst:
            return Self.sortNewestAddedFirst
        case .oldestAddedFirst:
            return Self.sortOldestAddedFirst
        case .aToz:
            return Self.sortAToZ
        case .zToa:
            return Self.sortZToA
        }
    }

    static let sortExpiringNearestFirst: ComparatorType = { left, right in left.expiryDate < right.expiryDate }
    static let sortExpiringFarestFirst: ComparatorType = { left, right in left.expiryDate > right.expiryDate }
    static let sortNewestAddedFirst: ComparatorType = { left, right in left.addedDate < right.addedDate }
    static let sortOldestAddedFirst: ComparatorType = { left, right in left.addedDate > right.addedDate }
    static let sortAToZ: ComparatorType = { left, right in left.name < right.name }
    static let sortZToA: ComparatorType = { left, right in left.name > right.name }
}

struct ItemSorter: View {
    @Binding var selection: OrderStyle

    var body: some View {
        Menu {
            Picker("Order", selection: self.$selection) {
                ForEach(OrderStyle.allCases, id: \.id) { item in
                    Text(item.id.capitalized).tag(item)
                }
            }
        } label: {
            Label("Order", systemImage: "line.3.horizontal.decrease")
        }
    }
}

#Preview {
    ItemSorter(selection: Binding.constant(.expiringFarestFirst))
}
