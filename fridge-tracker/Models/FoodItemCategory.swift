//
//  ItemCategory.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/19/23.
//

import Foundation

enum FoodItemCategory: String, Hashable, Codable {
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
    case Sugars
    case BabyFoods
    case BabyBeverages
    case InfantFormulas
    case HumanMilk
    case Leftover
    case CannedFood
    case Other
}

extension FoodItemCategory {
    var name: String {
        switch self {
        case .Milk:
            return "Milk"
        case .FlavoredMilk:
            return "Flavored Milk"
        case .DairyDrinksAndSubstitutes:
            return "Dairy Drinks and Substitutes"
        case .Cheese:
            return "Cheese"
        case .Yogurt:
            return "Yogurt"
        case .Meats:
            return "Meats"
        case .Poultry:
            return "Poultry"
        case .Seafood:
            return "Seafood"
        case .Eggs:
            return "Eggs"
        case .CuredMeatsOrPoultry:
            return "Cured Meats/Poultry"
        case .PlantbasedProteinFoods:
            return "Plant-based Protein Foods"
        case .CookedGrains:
            return "Cooked Grains"
        case .BreadsRollsTortillas:
            return "Breads, Rolls, Tortillas"
        case .QuickBreadsAndBreadProducts:
            return "Quick Breads and Bread Products"
        case .ReadyToEatCereals:
            return "Ready-to-Eat Cereals"
        case .CookedCereals:
            return "Cooked Cereals"
        case .SavorySnacks:
            return "Savory Snacks"
        case .Crackers:
            return "Crackers"
        case .SnackMealBars:
            return "Snack/Meal Bars"
        case .SweetBakeryProducts:
            return "Sweet Bakery Products"
        case .Candy:
            return "Candy"
        case .Desserts:
            return "Desserts"
        case .Fruits:
            return "Fruits"
        case .Vegetables:
            return "Vegetables"
        case .Juice:
            return "Juice"
        case .DietBeverages:
            return "Diet Beverages"
        case .SweetenedBeverages:
            return "Sweetened Beverages"
        case .CoffeeAndTea:
            return "Coffee and Tea"
        case .AlcoholicBeverages:
            return "Alcoholic Beverages"
        case .PlainWater:
            return "Plain Water"
        case .FlavoredOrEnhancedWater:
            return "Flavored or Enhanced Water"
        case .FatsAndOils:
            return "Fats and Oils"
        case .CondimentsAndSauces:
            return "Condiments and Sauces"
        case .Sugars:
            return "Sugars"
        case .BabyFoods:
            return "Baby Foods"
        case .BabyBeverages:
            return "Baby Beverages"
        case .InfantFormulas:
            return "Infant Formulas"
        case .HumanMilk:
            return "Human Milk"
        case .Leftover:
            return "Leftover"
        case .CannedFood:
            return "Canned Food"
        case .Other:
            return "Other"
        }
    }

    static var listing: String {
        Self.allCases.map { "- \($0.rawValue) : \($0.name)" }.joined(separator: "\n")
    }
}

extension FoodItemCategory: CaseIterable {
    static var allCases: [FoodItemCategory] {
        [
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
            .Sugars,
            .BabyFoods,
            .BabyBeverages,
            .InfantFormulas,
            .HumanMilk,
            .Leftover,
            .CannedFood,
            .Other,
        ]
    }
}
