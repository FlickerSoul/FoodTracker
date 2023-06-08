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
    
    private func toggleNotification() {
        if notificationOn, !archived {
            scheduleNotification()
        } else {
            cancelNotification()
        }
    }
    
    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Food '\(name)' is expiring today!"
        content.body = ""
        content.sound = .default
        
        let dateComponents = makeNotificationDateComponents(from: expiryDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                                            content: content, trigger: trigger)
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.add(request) { error in
            if error != nil {
                // TODO: better error handling
                print("error")
            } else {
                self.notificationIdentifiers.append(uuidString)
            }
        }
    }
    
    private func requestNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    private func cancelNotification() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: notificationIdentifiers)
        notificationIdentifiers.removeAll()
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
    
    static func makeDefaultFridgeItem(name: String = "Item name") -> FridgeItem {
        return Self(name: name)
    }
    
    static func isExpiring(item: FridgeItem) -> Bool {
        return item.expiryDate < Date.now
    }
}
