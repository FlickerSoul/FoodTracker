//
//  PreviewContainer.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/6/23.
//

import SwiftData

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: FoodItem.self,
            migrationPlan: FoodTrackerMigrationPlan.self,
            ModelConfiguration(inMemory: true)
        )

        for item in SampleFoodItems.items {
            container.mainContext.insert(item)
        }

        return container
    } catch {
        fatalError("Failed to create FoodItem container")
    }
}()
