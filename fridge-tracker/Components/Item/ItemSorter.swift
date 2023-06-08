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
    case newestAddedFirst = "newest added first"
    case expiringFarestFirst = "expiring farest first"
    case oldestAddedFirst = "oldest added first"

    var id: String {
        return self.rawValue
    }

    var comparator: ComparatorType {
        switch self {
        case .expiringNearstFirst:
            return { left, right in left.expiryDate < right.expiryDate }
        case .expiringFarestFirst:
            return { left, right in left.expiryDate > right.expiryDate }
        case .newestAddedFirst:
            return { left, right in left.addedDate < right.addedDate }
        case .oldestAddedFirst:
            return { left, right in left.addedDate > right.addedDate }
        }
    }
}

struct ItemSorter: View {
    @Binding var selection: OrderStyle

    var body: some View {
        Picker("Order", selection: self.$selection) {
            ForEach(OrderStyle.allCases, id: \.id) { item in
                Text(item.id.capitalized).tag(item)
            }
        }.pickerStyle(.menu)
    }
}

#Preview {
    ItemSorter(selection: Binding.constant(.expiringFarestFirst))
}
