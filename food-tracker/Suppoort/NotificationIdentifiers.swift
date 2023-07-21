//
//  NotificationIdentifiers.swift
//  food-tracker
//
//  Created by Heyuan Zeng on 7/21/23.
//

import Foundation

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
        case consumeAndArchive = "CONSUME_AND_ARCHIVE_ITEM"

        var id: String {
            self.rawValue
        }
    }
}
