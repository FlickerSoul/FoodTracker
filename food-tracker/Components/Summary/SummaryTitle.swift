//
//  SummaryTitle.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/12/23.
//

import SwiftUI

struct SummaryTitle<Content: View>: View {
    let titleText: String
    let tools: (() -> Content)?

    init(titleText: String, tools: (() -> Content)? = nil) {
        self.titleText = titleText
        self.tools = tools
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(titleText)
                    .font(.title)
                    .bold()
                Text("As for \(Date.now.formatted(date: .abbreviated, time: .omitted))").font(.footnote)
            }

            Spacer()

            if let tools = tools {
                tools()
            }
        }
        .padding(.horizontal)
    }
}
