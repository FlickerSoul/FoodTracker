//
//  FoodItemCategory+CaseIterable.swift
//  food-tracker
//
//  Created by Heyuan Zeng on 7/23/23.
//

import Foundation

extension FoodItemCategory: CaseIterable {
    static var allCases: [FoodItemCategory] {
        return [
        ]
    }
    
    static var allCasesExceptOther: [FoodItemCategory] {
        return []
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
