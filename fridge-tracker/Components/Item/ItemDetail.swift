//
//  ItemDetail.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/6/23.
//

import SwiftUI

struct ItemDetail: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var item: FridgeItem
    @Binding var adding: Bool
    @State private var canceling = false
    let wrapUp: () -> Void
    
    var titleText: String {
        if adding {
            return "Add Item"
        } else {
            return "Edit Item"
        }
    }
    
    var body: some View {
        VStack {
            List {
                Section(header: Label("Name", systemImage: "pencil")) {
                    TextField("Item Name", text: $item.name)
                }
                
                Section(header: Label("Date", systemImage: "pencil")) {
                    DatePicker("Expiry Date", selection: $item.expiryDate, displayedComponents: .date)
                    DatePicker("Added Date", selection: $item.addedDate, displayedComponents: .date)
                }
                
                Section(header: Label("Note", systemImage: "note")) {
                    TextEditor(text: $item.note)
                }
                
                Section(header: Label("Options", systemImage: "ellipsis")) {
                    Toggle("Notification", isOn: $item.notificationOn)
                    Toggle("Archive", isOn: $item.archived)
                }
            }
        }
        .navigationTitle(titleText)
        .toolbar {
            if adding {
                ToolbarItem {
                    Button(role: .destructive) {
                        canceling = true
                    } label: {
                        Text("cancel")
                    }.alert(
                        "Discard Changes?",
                        isPresented: $canceling)
                    {
                        Button("Yes", role: .destructive) {
                            wrapUp()
                        }
                    }
                }
            }
            
            ToolbarItem {
                Button {
                    wrapUp()
                } label: {
                    Text("save")
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview("adding") {
    MainView()
        .modelContainer(previewContainer)
}
