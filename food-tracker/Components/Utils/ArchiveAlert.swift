//
//  ArchiveAlert.swift
//  food-tracker
//
//  Created by Heyuan Zeng on 7/15/23.
//

import SwiftUI

struct ArchiveInfo {
    var toggle: Bool = false
    var title: String = ""
    var archiveState: Bool = false

    mutating func archiveItem() {
        title = "Archive this item?"
        archiveState = true
    }

    mutating func unarchiveItem() {
        title = "Unarchive this item?"
        archiveState = false
    }

    func alertView(item: Bindable<FoodItem>) -> Alert {
        return Alert(
            title: Text(title),
            primaryButton: .default(Text("Ok"), action: {
                item.wrappedValue.archived = self.archiveState
            }),
            secondaryButton: .cancel(Text("No"))
        )
    }
}
