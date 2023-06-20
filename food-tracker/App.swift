//
//  fridge_trackerApp.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/6/23.
//

import SwiftData
import SwiftUI

@main
struct FoodTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(for: FridgeItem.self)
    }
}
