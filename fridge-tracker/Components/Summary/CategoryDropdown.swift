//
//  CategoryDropdown.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/10/23.
//

import SwiftUI

struct CategoryDropdown: View {
    let info: PieChartView.ItemInfoType
    @Binding var opened: Bool

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "chevron.right")
                    .rotationEffect(opened ? .degrees(90) : .zero)

                Text("\(info.section.rawValue)").badge(
                    Text("\(info.count)")
                        .monospacedDigit()
                        .foregroundStyle(info.count > 0 ? info.section.color : .clear)
                )
            }
            .disabled(info.count == 0)
            .onTapGesture {
                withAnimation {
                    opened.toggle()
                }
            }
        }
    }
}
