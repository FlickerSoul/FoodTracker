//
//  Notification.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/10/23.
//

import Foundation
import os
import UserNotifications

let NOTIFICATION_LOGGER = Logger(subsystem: Bundle.main.bundlePath, category: "Notification")

enum NotificatioNCategoryIdentifier: String {
    case foodItemExpiring = "FOOD_ITEM_EXPIRING"
}

enum FoodItemNotificationAction: String {
    case archive = "ARHIVE_FOOD_ITEM"
    case view = "VIEW_FOOD_ITEM"
}

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
        content.title = "Food Expiring Today!"
        content.subtitle = "\"\(item.name.trimmingCharacters(in: .whitespacesAndNewlines))\" is expiring"
        content.body = """
        It was added on \(item.addedDate.formatted(date: .complete, time: .omitted))
        Click to see the details
        """
        content.sound = .default
        content.categoryIdentifier = NotificatioNCategoryIdentifier.foodItemExpiring.rawValue
        content.targetContentIdentifier = "\(item.id)"
        
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
                item.notificationIdentifiers!.insert(identifier)
            }
        }
    }
    
    func cancelNotification(item: FridgeItem) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: Array(item.notificationIdentifiers!))
        item.notificationIdentifiers!.removeAll()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        NOTIFICATION_LOGGER.debug("Application delegate method userNotificationCenter:didReceive:withCompletionHandler: is called with user info: \(response.notification.request.content.userInfo)")
        // ...
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        NOTIFICATION_LOGGER.debug("userNotificationCenter:willPresent")
        // ...
        completionHandler([.banner])
    }
}
