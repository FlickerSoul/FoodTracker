//
//  AppleDelegate+UNHandlers.swift
//  food-tracker
//
//  Created by Heyuan Zeng on 7/21/23.
//

import Foundation
import SwiftData
import UIKit
import UserNotifications

extension AppDelegate {
    func handleExpiredFoodNotification(for response: UNNotificationResponse) {
        NOTIFICATION_LOGGER.debug("Handling action \(response.actionIdentifier)")
        
        guard let itemIdentifier = response.notification.request.content.targetContentIdentifier else {
            NOTIFICATION_LOGGER.error("The notification did not associate item id to be the content identifier")
            return
        }
        
        switch response.actionIdentifier {
        case NotificationCategoryIdentifier.FoodItemNotificationAction.view.id, UNNotificationDefaultActionIdentifier:
            NOTIFICATION_LOGGER.debug("Viewing Item")
            self.handleViewAction(for: itemIdentifier)
        case NotificationCategoryIdentifier.FoodItemNotificationAction.archive.id:
            NOTIFICATION_LOGGER.debug("Archiving Item")
            self.handleArchiveAction(for: itemIdentifier)
        case NotificationCategoryIdentifier.FoodItemNotificationAction.consumeAndArchive.id:
            NOTIFICATION_LOGGER.debug("Consuming And Archiving Item")
            self.handleConsumeAndArchiveAction(for: itemIdentifier)
        default:
            NOTIFICATION_LOGGER.error("Invalid Notification Action For Expired Food")
        }
    }
    
    
    private func generateURL(for itemId: String, action: URLAction) -> URL {
        return URL(string: "\(FOOD_TRACKER_URL_SCHEME)://\(action.rawValue)?id=\(itemId)")!
    }
    
    func handleViewAction(for itemId: String) {
        UIApplication.shared.open(self.generateURL(for: itemId, action: .viewItem))
    }
    
    func handleArchiveAction(for itemId: String) {
        let item = fetchFoodItem(for: itemId)
        
        DispatchQueue.main.async {
            item.map { item in
                item.archived = true
            }
            try? mainContainer.mainContext.save()
        }
    }
    
    func handleConsumeAndArchiveAction(for itemId: String) {
        let item = fetchFoodItem(for: itemId)

        DispatchQueue.main.async {
            item.map { item in
                item.consumeAllAndArchive()
            }
            try? mainContainer.mainContext.save()
        }
    }
}
