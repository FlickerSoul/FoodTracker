//
//  SummaryTitle.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/12/23.
//

import SwiftUI

struct SummaryTitle<Content: View>: View {
    var tools: (() -> Content)? = nil

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Food Calendar")
                    .font(.title)
                    .bold()
                Text("As for \(Date.now.formatted(date: .abbreviated, time: .omitted))")
            }

            Spacer()

            if let tools = tools {
                tools()
            }
        }
        .padding(.horizontal)
    }
}
