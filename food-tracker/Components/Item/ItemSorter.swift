//
//  ItemFilter.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/7/23.
//

import SwiftData
import SwiftUI

enum OrderStyle: String, CaseIterable, Identifiable {
    typealias ComparatorType = (FoodItem, FoodItem) -> Bool

    case expiringNearstFirst = "expiring first"
    case expiringFarestFirst = "expiring farest first"
    case newestAddedFirst = "newest added first"
    case oldestAddedFirst = "oldest added first"
    case aToz = "A to Z"
    case zToa = "Z to A"

    var id: String {
        return rawValue
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

    var sortDescriptor: SortDescriptor<FoodItem> {
        switch self {
        case .expiringNearstFirst:
            return .init(\.expiryDate, order: .forward)
        case .expiringFarestFirst:
            return .init(\.expiryDate, order: .reverse)
        case .newestAddedFirst:
            return .init(\.addedDate, order: .forward)
        case .oldestAddedFirst:
            return .init(\.addedDate, order: .reverse)
        case .aToz:
            return .init(\.name, order: .forward)
        case .zToa:
            return .init(\.name, order: .reverse)
        }
    }

    func createQuery(filter: Predicate<FoodItem>? = nil) -> Query<FoodItem, [FoodItem]> {
        switch self {
        case .expiringNearstFirst:
            return Query(filter: filter, sort: \.expiryDate, order: .forward)
        case .expiringFarestFirst:
            return Query(filter: filter, sort: \.expiryDate, order: .reverse)
        case .newestAddedFirst:
            return Query(filter: filter, sort: \.addedDate, order: .forward)
        case .oldestAddedFirst:
            return Query(filter: filter, sort: \.addedDate, order: .reverse)
        case .aToz:
            return Query(filter: filter, sort: \.name, order: .forward)
        case .zToa:
            return Query(filter: filter, sort: \.name, order: .reverse)
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
