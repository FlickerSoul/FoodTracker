//
//  FoodItemCategory+CaseIterable.swift
//  food-tracker
//
//  Created by Heyuan Zeng on 7/23/23.
//

import Foundation

extension FoodItemCategory: CaseIterable {
    static var allCases: [FoodItemCategory] {
        return allCasesExceptOther + [.Other()]
    }
    
    static var allCasesExceptOther: [FoodItemCategory] {
        return [
            .Milk,
            .FlavoredMilk,
            .DairyDrinksAndSubstitutes,
            .Cheese,
            .Yogurt,
            .Meats,
            .Poultry,
            .Seafood,
            .Eggs,
            .CuredMeatsOrPoultry,
            .PlantbasedProteinFoods,
            .CookedGrains,
            .BreadsRollsTortillas,
            .QuickBreadsAndBreadProducts,
            .ReadyToEatCereals,
            .CookedCereals,
            .SavorySnacks,
            .Crackers,
            .SnackMealBars,
            .SweetBakeryProducts,
            .Candy,
            .Desserts,
            .Fruits,
            .Vegetables,
            .Juice,
            .DietBeverages,
            .SweetenedBeverages,
            .CoffeeAndTea,
            .AlcoholicBeverages,
            .PlainWater,
            .FlavoredOrEnhancedWater,
            .FatsAndOils,
            .CondimentsAndSauces,
            .Nuts,
            .Sugars,
            .BabyFoods,
            .BabyBeverages,
            .InfantFormulas,
            .HumanMilk,
            .Leftover,
            .CannedFood,
            .FrozenFood
        ]
    }
    
    static func from(name: String) -> Self {
        for cat in Self.allCasesExceptOther {
            if name == cat.name {
                return cat
            }
        }
        
        return .Other(cat: name)
    }
    
    private static func formatListingLine(_ index: Int, _ name: String) -> String {
        return "- \(index) : \(name)"
    }
    
    static var listing: String {
        Self.allCasesExceptOther.enumerated().map { index, item in formatListingLine(index, item.name) }.joined(separator: "\n") + "\n\(formatListingLine(allCasesExceptOther.count, "Other"))"
    }
}
