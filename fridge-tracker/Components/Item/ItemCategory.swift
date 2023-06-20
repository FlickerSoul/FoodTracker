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
        Text(category.name)
    }
}

#Preview {
    ItemCategory(category: .AlcoholicBeverages)
}
