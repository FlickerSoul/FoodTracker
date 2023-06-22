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

            let color: Color = {
                switch roundedDate {
                case Date.distantPast ..< today:
                    DateSection.alreadyExpired.color
                case today:
                    DateSection.oneDay.color
                case today + 1 * SECONDS_IN_A_DAY ..< today + 4 * SECONDS_IN_A_DAY:
                    DateSection.threeDays.color
                default:
                    DateSection.other.color
                }
            }()

            Text(date, format: .dateTime.year().month(.abbreviated).day(.twoDigits)).foregroundStyle(color)
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
