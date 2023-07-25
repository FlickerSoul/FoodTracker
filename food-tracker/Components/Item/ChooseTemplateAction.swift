//
//  ChooseTemplateAction.swift
//  food-tracker
//
//  Created by Heyuan Zeng on 6/25/23.
//

import SwiftUI

struct TemplateChoiceButton: View {
    let image: String
    let text: String
    let helperText: String
    let color: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25).opacity(0.2)
                .foregroundColor(color)

            HStack(spacing: 20) {
                VStack(alignment: .center) {
                    Image(systemName: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 50)

                    Text(text)
                }

                Divider()

                Text(helperText).font(.footnote)
            }
            .multilineTextAlignment(.center)
            .padding()
        }
        .frame(width: 300, height: 200)
    }
}

struct ChooseTemplateAction: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 20) {
                VStack(alignment: .center, spacing: 10) {
                    Text("Add Using Templates")
                        .font(.callout)

                    Text("Choose how you want to use templates").font(.headline)

                    VStack(alignment: .center, spacing: 2) {
                        Text("If the added date is 01/15/2001 and")
                        Text("the expiry date is 01/17/2001, then")
                    }
                    .font(.footnote)
                }
                .multilineTextAlignment(.center)
                .padding()
                .frame(width: 400)

                NavigationLink {
                    ChooseTemplateView(templateCreationStyle: .samePeriodOfTime)
                } label: {
                    TemplateChoiceButton(image: "calendar.badge.clock", text: "Use the same length of time", helperText: "expiry date would be today + 2 days", color: .orange)
                }
                .buttonStyle(.plain)

                NavigationLink {
                    ChooseTemplateView(templateCreationStyle: .sameExpiryDate)
                } label: {
                    TemplateChoiceButton(image: "calendar.badge.plus", text: "Use the same expiry date as the template", helperText: "expiry date would be 01/17/2001", color: .orange)
                }
                .buttonStyle(.plain)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel) {
                        dismiss()
                    } label: {
                        Text("cancel")
                    }
                }
            }
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        NavigationView(content: {
            NavigationLink(destination: Text("Destination")) { /*@START_MENU_TOKEN@*/Text("Navigate")/*@END_MENU_TOKEN@*/ }
        }).sheet(isPresented: Binding.constant(true), content: {
            ChooseTemplateAction()
        })
        .modelContainer(previewContainer)
    }
}
