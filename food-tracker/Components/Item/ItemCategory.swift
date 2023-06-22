//
//  ItemCategory.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/20/23.
//

import SwiftUI

struct ItemCategory: View {
    let category: FoodItemCategory

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: "filemenu.and.selection")
            Text(category.name)
        }
    }
}

#Preview {
    ItemCategory(category: .AlcoholicBeverages)
}
