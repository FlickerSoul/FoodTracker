//
//  ItemDetail.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/6/23.
//

import SwiftUI

struct ItemDetail: View {
    @Bindable var item: FridgeItem
    var adding: Bool
    
    var titleText: String {
        if adding {
            return "Add Item"
        } else {
            return "Edit Item"
        }
    }
    
    init(item: FridgeItem, adding: Bool) {
        self.item = item
        self.adding = adding
    }
    
    var body: some View {
        VStack {
            List {
                Section {
                    TextField("Item Name", text: $item.name)
                }
                
                Section {
                    DatePicker("Expiry Date", selection: $item.expiryDate)
                    DatePicker("Added Date", selection: $item.addedDate)
                }
                
                Section {
                    TextEditor(text: $item.note)
                }
            }
        }
        .padding()
        .navigationTitle(titleText)
    }
}

#Preview("adding") {
    MainView()
        .modelContainer(previewContainer)
}
