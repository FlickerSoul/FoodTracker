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
            requestNotification()
            scheduleNotification()
        } else {
            cancelNotification()
        }
        
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
            print(requests)
            print(self.notificationIdentifiers)
            
        })
    }
        
    private func scheduleNotification() {
        let today = roundDownToDate(date: Date.now)
        
        if roundDownToDate(date: expiryDate) < today {
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Food '\(name)' is expiring today!"
        content.subtitle = "It was added on \(addedDate.formatted(date: .complete, time: .omitted))"
        content.body = "Click to see the details"
        content.sound = .default
        
        let expiryDateComponent = getDateComponent(from: expiryDate)
        
        var trigger: UNNotificationTrigger?
        
        if expiryDateComponent != getDateComponent(from: today) {
            trigger = UNCalendarNotificationTrigger(dateMatching: expiryDateComponent, repeats: false)
        }
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                                            content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if error != nil {
                // TODO: decouple this part
                print("error")
            } else {
                self.notificationIdentifiers.append(uuidString)
            }
        }
    }
    
    private func requestNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, error in
            if let error = error {
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
    
    static func makeDefaultFridgeItem(name: String = "") -> FridgeItem {
        return Self(name: name)
    }
    
    static func isExpiring(item: FridgeItem) -> Bool {
        return item.expiryDate < Date.now
    }
}
