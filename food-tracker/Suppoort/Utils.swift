//
//  Utils.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/6/23.
//

import Foundation

let SECONDS_IN_A_DAY: Double = 24 * 3600

func roundDownToDate(date: Date) -> Date {
    return Calendar.current.startOfDay(for: date)
}

func getDateComponent(from date: Date) -> DateComponents {
    let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
    return components
}
