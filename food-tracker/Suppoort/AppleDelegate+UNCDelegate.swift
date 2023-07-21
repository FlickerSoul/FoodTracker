//
//  AppleDelegate+UNCDelegate.swift
//  food-tracker
//
//  Created by Heyuan Zeng on 7/21/23.
//

import Foundation
import UserNotifications
                               
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
