//
//  ItemCategory.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/19/23.
//

import Foundation
import UIKit

// SwiftData Bug: https://developer.apple.com/forums/thread/731538
enum FoodItemCategory: Int, Hashable, Codable, CaseIterable {
    case None
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
    case Other
}

extension FoodItemCategory {
    var name: String {
        switch self {
        case .None:
            return "None"
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
        case .Nuts:
            return "Nuts"
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

private extension String {
    func image() -> UIImage? {
        let size = CGSize(width: 32, height: 32)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 30)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension FoodItemCategory {
    var icon: UIImage {
        return iconName.image()!
    }

    private var iconName: String {
        switch self {
        case .None:
            return "🤔"
        case .Milk:
            return "🥛"
        case .FlavoredMilk:
            return "🥛"
        case .DairyDrinksAndSubstitutes:
            return "🥛"
        case .Cheese:
            return "🧀"
        case .Yogurt:
            return "🧉" // TODO: maybe change this?
        case .Meats:
            return "🍖"
        case .Poultry:
            return "🍗"
        case .Seafood:
            return "🍤"
        case .Eggs:
            return "🥚"
        case .CuredMeatsOrPoultry:
            return "🥓"
        case .PlantbasedProteinFoods:
            return "🫘"
        case .CookedGrains:
            return "🍚"
        case .BreadsRollsTortillas:
            return "🥖"
        case .QuickBreadsAndBreadProducts:
            return "🍞"
        case .ReadyToEatCereals:
            return "🥣"
        case .CookedCereals:
            return "🥣"
        case .SavorySnacks:
            return "🥨"
        case .Crackers:
            return "🍘"
        case .SnackMealBars:
            return "🍫"
        case .SweetBakeryProducts:
            return "🍩"
        case .Candy:
            return "🍭"
        case .Desserts:
            return "🍰"
        case .Fruits:
            return "🍓"
        case .Vegetables:
            return "🥦"
        case .Juice:
            return "🧃"
        case .DietBeverages:
            return "🫙"
        case .SweetenedBeverages:
            return "🧋"
        case .CoffeeAndTea:
            return "☕️"
        case .AlcoholicBeverages:
            return "🍺"
        case .PlainWater:
            return "💧"
        case .FlavoredOrEnhancedWater:
            return "🫧"
        case .FatsAndOils:
            return "🛢️"
        case .CondimentsAndSauces:
            return "🧂"
        case .Nuts:
            return "🌰"
        case .Sugars:
            return "🍬"
        case .BabyFoods:
            return "🍠"
        case .BabyBeverages:
            return "🍼"
        case .InfantFormulas:
            return "🍼"
        case .HumanMilk:
            return "🍼"
        case .Leftover:
            return "🥡"
        case .CannedFood:
            return "🥫"
        case .Other:
            return "🥄"
        }
    }
}
