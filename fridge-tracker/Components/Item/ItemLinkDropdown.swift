//
//  ItemLinkDropdown.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/7/23.
//

import SwiftUI

struct ItemLinkDropdown: View {
    let name: String
    let icon: String
    @Binding var open: Bool

    var body: some View {
        HStack(alignment: .center) {
            Label(name, systemImage: icon)

            Spacer()

            Image(systemName: "chevron.right")
                .rotationEffect(.degrees(open ? 90 : 0))
        }.onTapGesture {
            withAnimation {
                open.toggle()
            }
        }
    }
}

#Preview {
    ItemLinkDropdown(name: "inactive", icon: "archivebox", open: Binding(get: { true }, set: { _ in })).padding()
}
