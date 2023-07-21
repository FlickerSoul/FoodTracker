//
//  AppleDelegate+UNHandlers.swift
//  food-tracker
//
//  Created by Heyuan Zeng on 7/21/23.
//

import Foundation
import SwiftData
import UserNotifications
                                
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
