//
//  MigrationPlans.swift
//  food-tracker
//
//  Created by Heyuan Zeng on 7/14/23.
//

import SwiftData

enum FoodTrackerMigrationPlan: SchemaMigrationPlan {
    static var stages: [MigrationStage] {
        []
    }

    static var schemas: [any VersionedSchema.Type] {
        [FoodTrackerSchemeV1.self]
    }
}
