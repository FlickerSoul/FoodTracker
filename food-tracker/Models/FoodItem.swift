//
//  Item.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/6/23.
//

import Foundation
import SwiftData
import UserNotifications

@Model
final class FridgeItem {
    @Attribute(.unique) var id: UUID
    var name: String
    var note: String
    var addedDate: Date
    var expiryDate: Date
    
    var barcode: String
    
    var notificationOn: Bool = true {
        didSet {
            toggleNotification()
        }
    }
    
    var archived: Bool = false {
        didSet {
            toggleNotification()
        }
    }
    
    var notificationIdentifiers: [String]
    
    var category: FoodItemCategory
    
    var isTemplate: Bool
    
    var quantity: Int
    
    private var notificationScheduled: Bool {
        !notificationIdentifiers.isEmpty
    }
    
    func toggleNotification() {
        if notificationOn, !archived {
            NotificationHandler.current.requestNotification()
            NotificationHandler.current.scheduleNotification(item: self)
        } else {
            NotificationHandler.current.cancelNotification(item: self)
        }
    }
    
    init(name: String, barcode: String = "", note: String = "", addedDate: Date = Date.now, expiryDate: Date = Date.now, notificationOn: Bool = true, archived: Bool = false, notificationIdentifiers: [String] = [], category: FoodItemCategory = .None, isTemplate: Bool = false, quantity: Int = 1) {
        self.id = UUID()
        self.name = name
        self.barcode = barcode
        self.note = note
        self.addedDate = addedDate
        self.expiryDate = expiryDate
        self.notificationIdentifiers = notificationIdentifiers
        self.notificationOn = notificationOn
        self.archived = archived
        self.category = category
        self.isTemplate = isTemplate
        self.quantity = quantity
    }
    
    static func makeDefaultFridgeItem(name: String = "") -> FridgeItem {
        return Self(name: name)
    }
    
    static func isExpiring(item: FridgeItem) -> Bool {
        return item.expiryDate < Date.now
    }
    
    func copy() -> Self {
        return .init(
            name: name,
            barcode: barcode,
            note: note,
            addedDate: addedDate,
            expiryDate: expiryDate,
            notificationOn: notificationOn,
            archived: archived,
            notificationIdentifiers: notificationIdentifiers,
            category: category,
            isTemplate: isTemplate,
            quantity: quantity
        )
    }
    
    func copy(by style: TemplateCreationStyle) -> Self {
        switch style {
        case .sameExpiryDate:
            return .init(
                name: name,
                barcode: barcode,
                note: note,
                expiryDate: expiryDate,
                category: category,
                quantity: quantity
            )
        case .samePeriodOfTime:
            let now = Date.now
            return .init(
                name: name,
                barcode: barcode,
                note: note,
                addedDate: now,
                expiryDate: now + expiryDate.timeIntervalSince(addedDate),
                category: category,
                quantity: quantity
            )
        }
    }
}
