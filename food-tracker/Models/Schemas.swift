//
//  Item.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/6/23.
//

import Foundation
import SwiftData
import UserNotifications

enum FoodTrackerSchemeV1: VersionedSchema {
    static var versionIdentifier: String? = "0.1.0"
    
    static var models: [any PersistentModel.Type] {
        [Self.FoodItem.self]
    }
    
    @Model
    final class FoodItem {
        // swiftformat:disable:next all
        var id: UUID = UUID()
    
        var name: String = ""
        var note: String = ""
        // swiftformat:disable:next all
        var addedDate: Date = Date.now
        // swiftformat:disable:next all
        var expiryDate: Date = Date.now
    
        var barcode: String = ""
    
        // SwiftData bug? Related to https://developer.apple.com/forums/thread/731113
        @Attribute private var _notificationOn: Bool = true
        @Attribute(.transformable)
        var notificationOn: Bool {
            get {
                _$observationRegistrar.access(self, keyPath: \._notificationOn)
                return getValue(for: \._notificationOn)
            }
            set {
                _$observationRegistrar.withMutation(of: self, keyPath: \._notificationOn) {
                    self.setValue(for: \._notificationOn, to: newValue)
                }
                toggleNotification()
            }
        }
    
        @Attribute private var _archived: Bool = false
        @Attribute(.transformable)
        var archived: Bool {
            get {
                _$observationRegistrar.access(self, keyPath: \._archived)
                return getValue(for: \._archived)
            }
            set {
                _$observationRegistrar.withMutation(of: self, keyPath: \._archived) {
                    self.setValue(for: \._archived, to: newValue)
                }
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
        var category: FoodItemCategory = FoodItemCategory.None  // SwiftData bug, enum changes through Picker will not be persistent
    
        var isTemplate: Bool = false
    
        var quantity: Int = 1
        @Attribute private var _usedQuantity: Int = 0
        @Attribute(.transformable)
        var usedQuantity: Int {
            get {
                _$observationRegistrar.access(self, keyPath: \._usedQuantity)
                return getValue(for: \._usedQuantity)
            }
            set {
                _$observationRegistrar.withMutation(of: self, keyPath: \._usedQuantity) {
                    self.setValue(for: \._usedQuantity, to: newValue)
                }
                
                // archive this item if all has been consumed
                if newValue == quantity {
                    archived = true
                }
            }
        }
    
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
    
        static func makeDefaultFoodItem(name: String = "") -> Self {
            return Self(name: name)
        }
    
        static func isExpiring(item: FoodItem) -> Bool {
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
}

typealias LatestSchema = FoodTrackerSchemeV1
typealias FoodItem = LatestSchema.FoodItem
