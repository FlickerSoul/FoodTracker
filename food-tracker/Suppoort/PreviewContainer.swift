//
//  PreviewContainer.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/6/23.
//

import Foundation
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

@MainActor
func fetchItem(for itemId: String) -> FoodItem? {
    let context = mainContainer.mainContext

    // SwiftData bug workaround
    let uuid = UUID(uuidString: itemId)!
    let itemDescriptor = FetchDescriptor<FoodItem>(predicate: #Predicate { $0.id == uuid })

    let items = try? context.fetch(itemDescriptor) //

    guard let items = items, items.count == 1 else {
        NOTIFICATION_LOGGER.error("Cannot fetch corresponding item. Fetch result \(items?.description ?? "None")")
        return nil
    }

    return items[0]
}
