//
//  ItemFilter.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/7/23.
//

import SwiftUI

enum OrderStyle: String, CaseIterable, Identifiable {
    case all
    case expiringNearst = "expiring first"
    case newestAdded = "newest added"
    case expiringFarest = "expiring last"
    case oldestAdded = "oldest added"

    var id: String {
        return self.rawValue
    }
}

struct ItemFilter: View {
    @Binding var selection: OrderStyle

    var body: some View {
        Picker("Order", selection: $selection) {
            ForEach(OrderStyle.allCases, id: \.id) { item in
                Text(item.rawValue.capitalized)
            }
        }.pickerStyle(.menu)
    }
}

#Preview {
    ItemFilter(selection: Binding.constant(.all))
}
