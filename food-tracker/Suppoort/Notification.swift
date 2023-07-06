//
//  Notification.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/10/23.
//

import Foundation
import os
import SwiftData
import UserNotifications

let NOTIFICATION_LOGGER = Logger(subsystem: Bundle.main.bundlePath, category: "Notification")

enum NotificationCategoryIdentifier: String {
    case foodItemExpiring = "FOOD_ITEM_EXPIRING"
    
    var id: String {
        self.rawValue
    }
}

extension NotificationCategoryIdentifier {
    enum FoodItemNotificationAction: String {
        case archive = "ARHIVE_FOOD_ITEM"
        case view = "VIEW_FOOD_ITEM"
        
        var id: String {
            self.rawValue
        }
    }
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
    
    func makeNotificationContent(item: FoodItem) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Food Expiring Today!"
        content.subtitle = "\"\(item.name.trimmingCharacters(in: .whitespacesAndNewlines))\" is expiring"
        content.body = """
        It was added on \(item.addedDate.formatted(date: .complete, time: .omitted))
        Click to see the details
        """
        content.sound = .default
        content.categoryIdentifier = NotificationCategoryIdentifier.foodItemExpiring.id
        content.targetContentIdentifier = item.id.uuidString
        
        return content
    }
    
    func makeNotificationTrigger(item: FoodItem) -> UNNotificationTrigger? {
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
    
    func scheduleNotification(item: FoodItem) {
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
    
    func cancelNotification(item: FoodItem) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: item.notificationIdentifiers)
        item.notificationIdentifiers.removeAll()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        NOTIFICATION_LOGGER.debug("Application delegate method userNotificationCenter:didReceive:withCompletionHandler: is called with user info: \(response.notification.request.content.userInfo)")
        
        switch response.notification.request.content.categoryIdentifier {
        case NotificationCategoryIdentifier.foodItemExpiring.id:
            NOTIFICATION_LOGGER.debug("Got Food Expiring Tapped")
            handleExpiredFoodNotification(for: response)
        default:
            NOTIFICATION_LOGGER.debug("Unknown Notification")
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        NOTIFICATION_LOGGER.debug("userNotificationCenter:willPresent")
        // ...
        completionHandler([.list, .banner])
    }
    
    func setupNotificationCategory() {
        self.setupFoodItemCategory()
    }
    
    func setupFoodItemCategory() {
        let archiveAction = UNNotificationAction(identifier: NotificationCategoryIdentifier.FoodItemNotificationAction.archive.id,
                                                 title: "Archive",
                                                 options: [.destructive])
        let viewAction = UNNotificationAction(identifier: NotificationCategoryIdentifier.FoodItemNotificationAction.view.id,
                                              title: "View",
                                              options: [.foreground])
        
        // Define the notification type
        let meetingInviteCategory =
            UNNotificationCategory(identifier: NotificationCategoryIdentifier.foodItemExpiring.id,
                                   actions: [archiveAction, viewAction],
                                   intentIdentifiers: [],
                                   hiddenPreviewsBodyPlaceholder: "",
                                   options: .customDismissAction)
        
        // Register the notification type.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([meetingInviteCategory])
    }
}

extension AppDelegate {
    func handleExpiredFoodNotification(for response: UNNotificationResponse) {
        NOTIFICATION_LOGGER.debug("Hanlding action \(response.actionIdentifier)")
        
        switch response.actionIdentifier {
        case NotificationCategoryIdentifier.FoodItemNotificationAction.view.id, UNNotificationDefaultActionIdentifier:
            self.handleViewAction(for: response.notification.request.content.targetContentIdentifier)
        case NotificationCategoryIdentifier.FoodItemNotificationAction.archive.id:
            self.handleArchiveAction(for: response.notification.request.content.targetContentIdentifier)
        default:
            NOTIFICATION_LOGGER.error("Invalid Notification Action For Expired Food")
        }
    }
    
    func handleViewAction(for itemId: String?) {
        guard let itemId = itemId else { return }
    }
    
    func handleArchiveAction(for itemId: String?) {
        guard let itemId = itemId else { return }
        let context = mainContainer.mainContext
        
        // SwiftData bug workaround
        let uuid = UUID(uuidString: itemId)!
        let itemDescriptor = FetchDescriptor<FoodItem>(predicate: #Predicate { $0.id == uuid })
        
        let item = try? context.fetch(itemDescriptor) //
        guard let item = item, !item.isEmpty else { return }

        DispatchQueue.main.async {
            item[0].archived = true
            try? mainContainer.mainContext.save()
        }
    }
}
