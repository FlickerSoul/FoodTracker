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
    // swiftformat:disable:next all
    var id: UUID = UUID()
    
    var name: String = ""
    var note: String = ""
    // swiftformat:disable:next all
    var addedDate: Date = Date.now
    // swiftformat:disable:next all
    var expiryDate: Date = Date.now
    
    var barcode: String = ""
    
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

    @Attribute private var notificationIdentifiersEncoded: String = "" // TODO: ehhhh how to do transformable?
    
    @Attribute(.transformable) var notificationIdentifiers: [String] {
        get {
            _$observationRegistrar.access(self, keyPath: \.notificationIdentifiersEncoded)
            return getValue(for: \.notificationIdentifiersEncoded).components(separatedBy: ",")
        }
        set {
            _$observationRegistrar.withMutation(of: self, keyPath: \.notificationIdentifiersEncoded) {
                self.setValue(for: \.notificationIdentifiersEncoded, to: newValue.joined(separator: ","))
            }
        }
    }
    
    // swiftformat:disable:next all
    var category: FoodItemCategory = FoodItemCategory.None
    
    var isTemplate: Bool = false
    
    var quantity: Int = 1
    
    private var notificationScheduled: Bool {
        return !notificationIdentifiers.isEmpty
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
