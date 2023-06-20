//
//  SettingsView.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/6/23.
//

import SwiftUI

struct SettingsView: View {
    @State private var settings: SettingsConfig = .init()

    @AppStorage(SettingsKeys.openAIKey.rawValue) private var openAIkey = ""
    @AppStorage(SettingsKeys.autoFetch.rawValue) private var autoFetch: Bool = true

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("OpenAI API Key"), footer: Text("Enter your API key here for service like automatic item classification.")) {
                    TextField("OpenAI API Key", text: $openAIkey)
                        .disableAutocorrection(true)
                        .font(.body.monospaced())
                }

                Section(header: Text("Auto Fetch When Barcode Scanned"), footer: Text("Toggle auto fetching detail when barcode is scanned.")) {
                    Toggle("Auto Fetch", isOn: $autoFetch)
                }

                Section {
                    AboutLink()
                }
            }
            .navigationTitle("Settings")
            .onChange(of: settings) { _, newValue in
                newValue.store()
            }
        }
    }
}

#Preview {
    SettingsView()
}
