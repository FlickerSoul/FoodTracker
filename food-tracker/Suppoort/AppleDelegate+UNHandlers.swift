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
        
        guard let itemIdentifier = response.notification.request.content.targetContentIdentifier else {
            NOTIFICATION_LOGGER.error("The notification did not associate item id to be the content identifier")
            return
        }
        
        switch response.actionIdentifier {
        case NotificationCategoryIdentifier.FoodItemNotificationAction.view.id, UNNotificationDefaultActionIdentifier:
            self.handleViewAction(for: itemIdentifier)
        case NotificationCategoryIdentifier.FoodItemNotificationAction.archive.id:
            self.handleArchiveAction(for: itemIdentifier)
        case NotificationCategoryIdentifier.FoodItemNotificationAction.consumeAndArchive.id:
            self.handleViewAction(for: itemIdentifier)
        default:
            NOTIFICATION_LOGGER.error("Invalid Notification Action For Expired Food")
        }
    }
    
    private func fetchItems(for itemId: String) -> [FoodItem]? {
        let context = mainContainer.mainContext
        
        // SwiftData bug workaround
        let uuid = UUID(uuidString: itemId)!
        let itemDescriptor = FetchDescriptor<FoodItem>(predicate: #Predicate { $0.id == uuid })
        
        let items = try? context.fetch(itemDescriptor) //
        
        return items
    }
    
    private func fetchItem(for itemId: String) -> FoodItem? {
        let items = self.fetchItems(for: itemId)
        guard let items = items, items.count == 1 else {
            NOTIFICATION_LOGGER.error("Cannot fetch corresponding item. Fetch result \(items?.description ?? "None")")
            return nil
        }
        
        return items[0]
    }
    
    func handleViewAction(for itemId: String) {}
    
    func handleArchiveAction(for itemId: String) {
        let item = self.fetchItem(for: itemId)
        
        DispatchQueue.main.async {
            item.map { item in
                item.archived = true
            }
            try? mainContainer.mainContext.save()
        }
    }
    
    func handleConsumeAndArchiveAction(for itemId: String) {
        let item = self.fetchItem(for: itemId)

        DispatchQueue.main.async {
            item.map { item in
                item.consumeAllAndArchive()
            }
            try? mainContainer.mainContext.save()
        }
    }
}
