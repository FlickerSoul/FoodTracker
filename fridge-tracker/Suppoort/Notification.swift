//
//  Notification.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/10/23.
//

import Foundation
import UserNotifications

class NotificationHandler: ObservableObject {
    static let current = NotificationHandler()
    
    func requestNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func makeNotificationContent(item: FridgeItem) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Food '\(item.name)' is expiring today!"
        content.subtitle = "It was added on \(item.addedDate.formatted(date: .complete, time: .omitted))"
        content.body = "Click to see the details"
        content.sound = .default
        
        return content
    }
    
    func makeNotificationTrigger(item: FridgeItem) -> UNNotificationTrigger? {
        let today = roundDownToDate(date: Date.now)
        let expiryDate = roundDownToDate(date: item.expiryDate)
        
        var trigger: UNNotificationTrigger?
        
        if expiryDate > today {
            trigger = UNCalendarNotificationTrigger(dateMatching: getDateComponent(from: expiryDate), repeats: false)
        }
        
        return trigger
    }
    
    func addNotification(content: UNNotificationContent, trigger: UNNotificationTrigger?, callback: @escaping (String, Error?) -> Void) {
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                                            content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in callback(uuidString, error) })
    }
    
    func scheduleNotification(item: FridgeItem) {
        let content = NotificationHandler.current.makeNotificationContent(item: item)
        let trigger = NotificationHandler.current.makeNotificationTrigger(item: item)
            
        NotificationHandler.current.addNotification(content: content, trigger: trigger) { identifier, error in
            if error != nil {
                print("error")
            } else {
                item.notificationIdentifiers.append(identifier)
            }
        }
    }
    
    func cancelNotification(item: FridgeItem) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: item.notificationIdentifiers)
        item.notificationIdentifiers.removeAll()
    }
}
