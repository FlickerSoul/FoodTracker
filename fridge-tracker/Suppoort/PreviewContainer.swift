//
//  PreviewContainer.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/6/23.
//

import SwiftData


var previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: FridgeItem.self, ModelConfiguration(inMemory: true)
        )
        
        for item in SampleFridgeItems.items {
            Task {
                await MainActor.run {() -> Void in
                    container.mainContext.insert(item)
                }
            }
        }
        
        return container
    } catch {
        fatalError("Failed to create FridgeItem container")
    }
}()
