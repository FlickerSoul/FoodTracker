//
//  ItemCategory.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/19/23.
//

import Foundation

// SwiftData Bug: https://developer.apple.com/forums/thread/731538
enum FoodItemCategory: Hashable, Codable {
    case Milk
    case FlavoredMilk
    case DairyDrinksAndSubstitutes
    case Cheese
    case Yogurt
    case Meats
    case Poultry
    case Seafood
    case Eggs
    case CuredMeatsOrPoultry
    case PlantbasedProteinFoods
    case CookedGrains
    case BreadsRollsTortillas
    case QuickBreadsAndBreadProducts
    case ReadyToEatCereals
    case CookedCereals
    case SavorySnacks
    case Crackers
    case SnackMealBars
    case SweetBakeryProducts
    case Candy
    case Desserts
    case Fruits
    case Vegetables
    case Juice
    case DietBeverages
    case SweetenedBeverages
    case CoffeeAndTea
    case AlcoholicBeverages
    case PlainWater
    case FlavoredOrEnhancedWater
    case FatsAndOils
    case CondimentsAndSauces
    case Nuts
    case Sugars
    case BabyFoods
    case BabyBeverages
    case InfantFormulas
    case HumanMilk
    case Leftover
    case CannedFood
    case FrozenFood
    case Other(cat: String = "Unknown")
}
