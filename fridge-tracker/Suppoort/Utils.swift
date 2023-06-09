//
//  Utils.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/6/23.
//

import Foundation

func roundDownToDate(date: Date) -> Date {
    let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
    return Calendar.current.date(from: components)!
}

func getDateComponent(from date: Date) -> DateComponents {
    let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
    return components
}
