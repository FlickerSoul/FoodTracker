//
//  ItemFilter.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/8/23.
//

import SwiftUI

struct ItemFilter: View {
    @Binding var filtering: Bool
    var text: String = "Filter"

    var body: some View {
        Button {
            withAnimation {
                filtering.toggle()
            }
        } label: {
            Label(text, systemImage: filtering ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                .contentTransition(.symbolEffect(.replace.downUp.byLayer))
        }
    }
}

#Preview {
    ItemFilter(filtering: Binding.constant(true))
}
