//
//  ItemDate.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/20/23.
//

import SwiftUI

struct ItemDate: View {
    let date: Date

    init(date: Date) {
        self.date = date
    }

    var today: Date {
        roundDownToDate(date: Date.now)
    }

    var roundedDate: Date {
        roundDownToDate(date: date)
    }

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: "calendar")

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
        }
    }
}

#Preview("Color Item Date Expired") {
    ItemDate(date: Date.now - SECONDS_IN_A_DAY)
}

#Preview("Color Item Date Today") {
    ItemDate(date: Date.now)
}

#Preview("Color Item Date In Three days") {
    ItemDate(date: Date.now + 2 * SECONDS_IN_A_DAY)
}

#Preview("Color Item Date Old") {
    ItemDate(date: Date.now + 4 * SECONDS_IN_A_DAY)
}
