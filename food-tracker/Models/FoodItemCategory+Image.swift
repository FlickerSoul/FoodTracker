//
//  FoodItemCategory+Image.swift
//  food-tracker
//
//  Created by Heyuan Zeng on 7/23/23.
//

import Foundation
import UIKit

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
            return "🫐"
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
        case .FrozenFood:
            return "🧊"
        case .Other:
            return "🤔"
        }
    }
}
