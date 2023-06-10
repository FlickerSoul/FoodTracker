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
        
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
            print(requests)
            print(self.notificationIdentifiers)
            
        })
    }
        
    init(name: String, note: String = "", addedDate: Date = Date.now, expiryDate: Date = Date.now, notificationOn: Bool = true, archived: Bool = false, notificationIdentifiers: [String] = []) {
        self.id = UUID()
        self.name = name
        self.note = note
        self.addedDate = addedDate
        self.expiryDate = expiryDate
        self.notificationIdentifiers = notificationIdentifiers
        self.notificationOn = notificationOn
        self.archived = archived
    }
    
    static func makeDefaultFridgeItem(name: String = "") -> FridgeItem {
        return Self(name: name)
    }
    
    static func isExpiring(item: FridgeItem) -> Bool {
        return item.expiryDate < Date.now
    }
}
