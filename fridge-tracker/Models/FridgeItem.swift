//
//  Item.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/6/23.
//

import Foundation
import SwiftData

@Model
final class FridgeItem {
    @Attribute(.unique) var id: UUID
    var name: String
    var note: String
    var addedDate: Date
    var expiryDate: Date
    var notificationOn: Bool
    var archived: Bool

    init(name: String, note: String = "", addedDate: Date = Date.now, expiryDate: Date = Date.now, notificationOn: Bool = true, archived: Bool = false) {
        self.id = UUID()
        self.name = name
        self.note = note
        self.addedDate = addedDate
        self.expiryDate = expiryDate
        self.notificationOn = notificationOn
        self.archived = archived
    }

    static func makeDefaultFridgeItem(name: String = "Item name") -> FridgeItem {
        return Self(name: name)
    }
}
