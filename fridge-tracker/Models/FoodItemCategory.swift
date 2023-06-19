//
//  ItemCategory.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/19/23.
//

import Foundation

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
    case Sugars
    case BabyFoods
    case BabyBeverages
    case InfantFormulas
    case HumanMilk
    case Other(label: String = "")
    case Leftover(label: String = "")
    case CannedFood(label: String = "")
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
        case .Other(label: let label):
            return "Other - \(label)"
        case .Leftover(label: let label):
            return "Leftover - \(label)"
        case .CannedFood(label: let label):
            return "Canned Food - \(label)"
        }
    }

    static var listing: String {
        Self.allCases.map { "- \($0)" }.joined(separator: "\n")
    }
}

extension FoodItemCategory {
    var description: String {
        switch self {
        case .Milk:
            return ""
        case .FlavoredMilk:
            return ""
        case .DairyDrinksAndSubstitutes:
            return ""
        case .Cheese:
            return ""
        case .Yogurt:
            return ""
        case .Meats:
            return ""
        case .Poultry:
            return ""
        case .Seafood:
            return ""
        case .Eggs:
            return ""
        case .CuredMeatsOrPoultry:
            return ""
        case .PlantbasedProteinFoods:
            return ""
        case .CookedGrains:
            return ""
        case .BreadsRollsTortillas:
            return ""
        case .QuickBreadsAndBreadProducts:
            return ""
        case .ReadyToEatCereals:
            return ""
        case .CookedCereals:
            return ""
        case .SavorySnacks:
            return ""
        case .Crackers:
            return ""
        case .SnackMealBars:
            return ""
        case .SweetBakeryProducts:
            return ""
        case .Candy:
            return ""
        case .Desserts:
            return ""
        case .Fruits:
            return ""
        case .Vegetables:
            return ""
        case .Juice:
            return ""
        case .DietBeverages:
            return ""
        case .SweetenedBeverages:
            return ""
        case .CoffeeAndTea:
            return ""
        case .AlcoholicBeverages:
            return ""
        case .PlainWater:
            return ""
        case .FlavoredOrEnhancedWater:
            return ""
        case .FatsAndOils:
            return ""
        case .CondimentsAndSauces:
            return ""
        case .Sugars:
            return ""
        case .BabyFoods:
            return ""
        case .BabyBeverages:
            return ""
        case .InfantFormulas:
            return ""
        case .HumanMilk:
            return "Human Milk"
        case .Other(label: let label):
            return "Other - \(label)"
        case .Leftover(label: let label):
            return "Leftover - \(label)"
        case .CannedFood(label: let label):
            return "Canned Food - \(label)"
        }
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
            .Other(),
            .Leftover(),
            .CannedFood()
        ]
    }
}
