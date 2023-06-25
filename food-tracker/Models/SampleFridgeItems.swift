//
//  SamepleItems.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/6/23.
//
import Foundation

@MainActor
enum SampleFridgeItems {
    static var testSampleItem: FridgeItem {
        Self.items[0]
    }

    static var items: [FridgeItem] = [
        FridgeItem(
            name: "cake",
            note: "brought today",
            addedDate: Date.now,
            expiryDate: Date.now + 2 * SECONDS_IN_A_DAY,
            category: .Desserts
        ),
        FridgeItem(
            name: "stolen cake",
            note: "brought today",
            addedDate: Date.now,
            expiryDate: Date.now + 3 * SECONDS_IN_A_DAY,
            archived: true,
            category: .Desserts
        ),
        FridgeItem(
            name: "Banana",
            note: "this is something I buy very often",
            addedDate: Date.now - 2 * SECONDS_IN_A_DAY,
            expiryDate: Date.now + 5 * SECONDS_IN_A_DAY,
            category: .Fruits,
            isTemplate: true
        ),
        FridgeItem(
            name: "yogert",
            note: "this is also something I buy very often",
            addedDate: Date.now - 2 * SECONDS_IN_A_DAY,
            expiryDate: Date.now + 1 * SECONDS_IN_A_DAY,
            notificationOn: false,
            category: .Yogurt,
            isTemplate: true
        ),
        FridgeItem(
            name: "Fish Balls",
            addedDate: Date.now - 2 * SECONDS_IN_A_DAY,
            expiryDate: Date.now - 1 * SECONDS_IN_A_DAY,
            archived: true,
            category: .FrozenFood
        ),
        FridgeItem(
            name: "so expired",
            note: "also from the big shopping",
            addedDate: Date.now - 10 * SECONDS_IN_A_DAY,
            expiryDate: Date.now - 5 * SECONDS_IN_A_DAY,
            archived: true
        ),
        FridgeItem(
            name: "I have forgotten this",
            note: "also from the big shopping",
            addedDate: Calendar.current.date(from: DateComponents(year: 2023, month: 6, day: 7))!,
            expiryDate: Calendar.current.date(from: DateComponents(year: 2023, month: 6, day: 7))! + 2 * SECONDS_IN_A_DAY,
            archived: false
        ),
        FridgeItem(
            name: "Need to throw this today",
            addedDate: Date.now - 3 * SECONDS_IN_A_DAY,
            expiryDate: Date.now,
            archived: false
        ),
        FridgeItem(
            name: "Food that can last a long time",
            addedDate: Calendar.current.date(from: DateComponents(year: 2023, month: 6, day: 7))!,
            expiryDate: Date.now + 20 * SECONDS_IN_A_DAY,
            archived: false
        ),
        FridgeItem(
            name: "Food that can last forever",
            note: "I buy it once a year",
            addedDate: Calendar.current.date(from: DateComponents(year: 2023, month: 6, day: 7))!,
            expiryDate: Date.now + 366 * SECONDS_IN_A_DAY,
            archived: false,
            isTemplate: true
        ),
    ]
}
