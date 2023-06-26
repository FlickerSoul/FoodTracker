//
//  ItemFilter.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/8/23.
//

import SwiftUI

protocol FoodItemFilter {
    var filter: (FoodItem) -> Bool { get }
}

protocol HasNone {
    static var none: Self { get }
}

enum ExpiringFilterStyle: String, CaseIterable, FoodItemFilter, HasNone {
    case seeExpired = "See Expired"
    case seeNotExpired = "See Not Expired"
    case none = "None"

    var filter: (FoodItem) -> Bool {
        let today = roundDownToDate(date: Date.now)

        switch self {
        case .seeExpired:
            return {
                $0.expiryDate < today
            }
        case .seeNotExpired:
            return {
                $0.expiryDate >= today
            }
        case .none:
            return { _ in true }
        }
    }
}

enum ArchiveFilterStyle: String, CaseIterable, FoodItemFilter, HasNone {
    case seeArchived = "See Archived"
    case seeNotArchived = "See Not Archived"
    case none = "None"

    var filter: (FoodItem) -> Bool {
        switch self {
        case .seeArchived:
            return {
                $0.archived
            }
        case .seeNotArchived:
            return {
                !$0.archived
            }
        case .none:
            return { _ in true }
        }
    }
}

struct ItemFilter<FilterType: CaseIterable & RawRepresentable & HasNone>: View where FilterType.AllCases: RandomAccessCollection, FilterType.RawValue: Hashable & StringProtocol {
    @Binding var filtering: FilterType
    var text: String = "Filter"

    var body: some View {
        Menu {
            ForEach(FilterType.allCases, id: \.rawValue) { item in

                Button {
                    withAnimation {
                        filtering = item
                    }
                } label: {
                    HStack {
                        Text(item.rawValue)
                        if filtering == item {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }

        } label: {
            Label(text, systemImage:
                filtering == .none ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                .contentTransition(.symbolEffect(.replace.downUp.byLayer))
        }
    }
}

#Preview {
    ItemFilter<ExpiringFilterStyle>(filtering: Binding.constant(.none))
}
