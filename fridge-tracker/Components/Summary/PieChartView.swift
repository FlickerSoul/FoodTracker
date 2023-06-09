//
//  PieChartView.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/9/23.
//

import Charts
import SwiftUI

#if DEBUG
    import SwiftData
#endif

enum DateSection: String, CaseIterable {
    case alreadyExpired = "already expired"
    case oneDay = "1 day"
    case oneWeek = "7 days"
    case oneMonth = "30 days"
    case oneYear = "365 days"

    private static let secondsOfADay: Double = 24 * 3600

    private var begin: Date {
        let date = roundDownToDate(date: Date.now)

        switch self {
        case .alreadyExpired:
            return Date.distantPast
        case .oneDay:
            return date
        case .oneWeek:
            return date + Self.secondsOfADay
        case .oneMonth:
            return date + 7 * Self.secondsOfADay
        case .oneYear:
            return date + 30 * Self.secondsOfADay
        }
    }

    var timeRange: Range<Date> {
        let date = roundDownToDate(date: Date.now)

        switch self {
        case .alreadyExpired:
            return Date.distantPast..<date
        case .oneDay:
            return self.begin..<(date + Self.secondsOfADay)
        case .oneWeek:
            return self.begin..<(date + 7 * Self.secondsOfADay)
        case .oneMonth:
            return self.begin..<(date + 30 * Self.secondsOfADay)
        case .oneYear:
            return self.begin..<(date + 365 * Self.secondsOfADay)
        }
    }
}

struct PieChartView: View {
    #if DEBUG
        @Query var items: [FridgeItem]
    #else
        var items: [FridgeItem]
    #endif

    private typealias ItemInfoType = [String: [FridgeItem]]

    private typealias ItemCountInfoType = [(name: String, count: Int)]

    private(set) var sections: [DateSection] = DateSection.allCases

    private var itemInfoBySections: ItemInfoType {
        return self.sections.reduce(into: ItemInfoType()) { dict, section in
            dict[section.rawValue] = self.items.filter { item in
                section.timeRange.contains(item.expiryDate)
            }
        }
    }

    private var itemCountBySections: ItemCountInfoType {
        return self.itemInfoBySections.map { name, items in
            (name: name, count: items.count)
        }
    }

    private var selectedName: String? {
        if var value = selectedValue {
            for (name, count) in self.itemCountBySections {
                value -= count
                if value <= 0 {
                    return name
                }
            }
        }

        return nil
    }

    private var noItems: Bool {
        return self.items.count == 0
    }

    @State private var selectedValue: Int? = nil
    @State private var nameStack: [String] = []

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                Chart(self.itemCountBySections, id: \.name) { name, count in
                    SectorMark(
                        angle: .value("Count", count),
                        innerRadius: .ratio(0.618),
                        angularInset: 2
                    )
                    .cornerRadius(5)
                    .foregroundStyle(by: .value("Name", name))
                }
                .chartLegend(position: .bottom, alignment: .center, spacing: 20)
                .chartAngleSelection(self.$selectedValue)
                .chartBackground { chartProxy in
                    GeometryReader { geometry in
                        let frame = geometry[chartProxy.plotAreaFrame]

                        VStack(alignment: .center) {
                            if self.noItems {
                                Text("No Items")
                            } else {
                                Text("Expiring Food")
                                    .font(.title2)
                                    .bold()
                                Text("By")
                                Text("Dates")
                            }
                        }.position(x: frame.midX, y: frame.midY)
                    }
                }
                .frame(maxHeight: geometry.size.width)

                Text("This is helper text")

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    PieChartView()
        .modelContainer(previewContainer)
}
