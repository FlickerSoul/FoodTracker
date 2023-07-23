//
//  FoodItemCategory+Name.swift
//  food-tracker
//
//  Created by Heyuan Zeng on 7/23/23.
//

import Foundation

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
        case .FrozenFood:
            return "Frozen Food"
        case .Other(let cat):
            return cat
        }
    }
}
