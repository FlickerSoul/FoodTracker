//
//  SamepleItems.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/6/23.
//
import Foundation

struct SampleFridgeItems {
    static var items: [FridgeItem] = [
        FridgeItem(
            name: "cake",
            note: "brought today",
            addedDate: Date.now,
            expiryDate: Date.now + 2 * SECONDS_IN_A_DAY
        ),
        FridgeItem(
            name: "Banana",
            note: "from a big shopping",
            addedDate: Date.now - 2 * SECONDS_IN_A_DAY,
            expiryDate: Date.now + 5 * SECONDS_IN_A_DAY
        ),
        FridgeItem(
            name: "yogert",
            note: "also from the big shopping",
            addedDate: Date.now - 2 * SECONDS_IN_A_DAY,
            expiryDate: Date.now + 1 * SECONDS_IN_A_DAY,
            notificationOn: false
        ),
        FridgeItem(
            name: "expired",
            note: "also from the big shopping",
            addedDate: Date.now - 2 * SECONDS_IN_A_DAY,
            expiryDate: Date.now - 1 * SECONDS_IN_A_DAY,
            archived: true
        ),

        FridgeItem(
            name: "so expired",
            note: "also from the big shopping",
            addedDate: Date.now - 10 * SECONDS_IN_A_DAY,
            expiryDate: Date.now - 5 * SECONDS_IN_A_DAY,
            archived: true
        ),
    ]
}
