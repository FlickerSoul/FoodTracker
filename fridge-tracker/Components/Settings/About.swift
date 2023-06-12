//
//  About.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/12/23.
//

import SwiftUI

struct About: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("Food Tracker").font(.title).bold()

            Text("by Larry Zeng")

            Text("2023 ©")

            Link("hi@universe.observer", destination: URL(string: "mailto: hi@universe.observer")!)
        }
        .padding()
        .navigationTitle("About")
    }
}

struct AboutLink: View {
    var body: some View {
        NavigationLink {
            About()
        } label: {
            Text("About")
        }
    }
}

#Preview {
    NavigationView {
        About()
    }
}
