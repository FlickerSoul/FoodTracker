//
//  SamepleItems.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/6/23.
//
import Foundation

struct SampleFridgeItems {
    static let items: [FridgeItem] = [
        FridgeItem(
            name: "cake",
            note: "brought today",
            addedDate: Date.now,
            expiryDate: Date.now + 2 * 24 * 3600
        ),
        FridgeItem(
            name: "Banana",
            note: "from a big shopping",
            addedDate: Date.now - 2 * 24 * 3600,
            expiryDate: Date.now + 5 * 24 * 3600
        ),
        FridgeItem(
            name: "yogert",
            note: "also from the big shopping",
            addedDate: Date.now - 2 * 24 * 3600,
            expiryDate: Date.now + 1 * 24 * 3600,
            notificationOn: false
        ),
        FridgeItem(
            name: "food",
            note: "also from the big shopping",
            addedDate: Date.now - 2 * 24 * 3600,
            expiryDate: Date.now + 1 * 24 * 3600,
            archived: true
        )
    ]
}
