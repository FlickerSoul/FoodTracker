//
//  SharedContainer.swift
//  food-tracker
//
//  Created by Heyuan Zeng on 6/28/23.
//

import Foundation
import SwiftData

@MainActor
let mainContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: FoodItem.self,
            migrationPlan: FoodTrackerMigrationPlan.self,
            ModelConfiguration(cloudKitContainerIdentifier: "observer.universe.food-tracker")
        )

        return container
    } catch {
        fatalError("Failed to create FoodItem container")
    }
}()
