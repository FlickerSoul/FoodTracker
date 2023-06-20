//
//  ItemDate.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/20/23.
//

import SwiftUI

struct ItemDate: View {
    let name: String
    let date: Date
    let color: Bool

    init(name: String, date: Date, color: Bool = false) {
        self.name = name
        self.date = date
        self.color = color
    }

    var displayName: String {
        return "\(name):"
    }

    var today: Date {
        roundDownToDate(date: Date.now)
    }

    var roundedDate: Date {
        roundDownToDate(date: date)
    }

    var body: some View {
        HStack(spacing: 5) {
            Text(displayName)

            if color {
                switch roundedDate {
                case Date.distantPast ..< today:
                    Text(date, style: .date).foregroundStyle(DateSection.alreadyExpired.color)
                case today:
                    Text(date, style: .date).foregroundStyle(DateSection.oneDay.color)
                case today + 1 * SECONDS_IN_A_DAY ..< today + 4 * SECONDS_IN_A_DAY:
                    Text(date, style: .date).foregroundStyle(DateSection.threeDays.color)
                default:
                    Text(date, style: .date).foregroundStyle(DateSection.other.color)
                }

            } else {
                Text(date, style: .date)
            }
        }
    }
}

#Preview("Color Item Date Expired") {
    ItemDate(name: "Expiry Date", date: Date.now - SECONDS_IN_A_DAY, color: true)
}

#Preview("Color Item Date Today") {
    ItemDate(name: "Expiry Date", date: Date.now, color: true)
}

#Preview("Color Item Date In Three days") {
    ItemDate(name: "Expiry Date", date: Date.now + 2 * SECONDS_IN_A_DAY, color: true)
}

#Preview("Color Item Date Old") {
    ItemDate(name: "Expiry Date", date: Date.now + 4 * SECONDS_IN_A_DAY, color: true)
}

#Preview("No Color Item Date") {
    ItemDate(name: "Expiry Date", date: Date.now + 24 * 3600)
}
