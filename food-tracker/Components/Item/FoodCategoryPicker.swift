//
//  FoodCategoryPicker.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/20/23.
//

import SwiftUI

struct FoodCategoryPicker: View {
    @Binding var category: FoodItemCategory
    var body: some View {
        Picker("Food Category", selection: $category) {
            ForEach(FoodItemCategory.allCases, id: \.name) { item in
                Text(item.name).tag(item)
            }
        }
    }
}

#Preview {
    FoodCategoryPicker(category: Binding.constant(.AlcoholicBeverages))
}
