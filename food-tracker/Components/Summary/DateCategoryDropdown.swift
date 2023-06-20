//
//  DateCategoryDropdown.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/10/23.
//

import SwiftUI

struct DateCategoryDropdown: View {
    let info: PieChartView.ItemInfoType
    @Binding var opened: Bool

    var body: some View {
        VStack {
            HStack {
                RoundedRectangle(cornerRadius: 10).frame(maxWidth: 5).foregroundStyle(info.section.color)
                Image(systemName: "chevron.right")
                    .rotationEffect(opened ? .degrees(90) : .zero)

                Text("\(info.section.rawValue)").badge(
                    Text("\(info.count)")
                        .monospacedDigit()
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
