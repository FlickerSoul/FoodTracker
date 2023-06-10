//
//  ItemDetail.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/6/23.
//

import SwiftUI

struct ItemDetail: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var item: FridgeItem
    @Binding var adding: Bool
    @State private var canceling = false
    @State private var showInvalidAleart = false
    
    var titleText: String {
        if adding {
            return "Add Item"
        } else {
            return "Edit Item"
        }
    }
    
    private var isItemInvalid: Bool {
        item.name.isEmpty
    }
    
    var body: some View {
        VStack {
            List {
                Section(header: Label("Name", systemImage: "pencil")) {
                    TextField("Give a name to this item", text: $item.name)
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
                ToolbarItem(placement: .cancellationAction) {
                    Button("cancel") {
                        canceling = true
                    }.alert(
                        "Discard Changes?",
                        isPresented: $canceling
                    ) {
                        Button("Yes", role: .destructive) {
                            dismiss()
                        }
                    }
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    if adding {
                        modelContext.insert(item)
                    }
                    
                    dismiss()
                } label: {
                    Text("save")
                }.disabled(isItemInvalid)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview("adding") {
    MainView()
        .modelContainer(previewContainer)
}
