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

enum DateSection: String, CaseIterable, Plottable {
    case alreadyExpired = "Already expired"
    case oneDay = "1 day"
    case oneWeek = "7 days"
    case oneMonth = "30 days"
    case oneYear = "365 days"

    private var begin: Date {
        let date = roundDownToDate(date: Date.now)

        switch self {
        case .alreadyExpired:
            return Date.distantPast
        case .oneDay:
            return date
        case .oneWeek:
            return date + SECONDS_IN_A_DAY
        case .oneMonth:
            return date + 7 * SECONDS_IN_A_DAY
        case .oneYear:
            return date + 30 * SECONDS_IN_A_DAY
        }
    }

    var timeRange: Range<Date> {
        let date = roundDownToDate(date: Date.now)

        switch self {
        case .alreadyExpired:
            return Date.distantPast..<date
        case .oneDay:
            return self.begin..<(date + SECONDS_IN_A_DAY)
        case .oneWeek:
            return self.begin..<(date + 7 * SECONDS_IN_A_DAY)
        case .oneMonth:
            return self.begin..<(date + 30 * SECONDS_IN_A_DAY)
        case .oneYear:
            return self.begin..<(date + 365 * SECONDS_IN_A_DAY)
        }
    }

    var color: Color {
        switch self {
        case .alreadyExpired:
            return .red
        case .oneDay:
            return .orange
        case .oneWeek:
            return .yellow
        case .oneMonth:
            return .green
        case .oneYear:
            return .teal
        }
    }
}

struct PieChartView: View {
    #if DEBUG
        @Query var items: [FridgeItem]
    #else
        var items: [FridgeItem]
    #endif

    private let sections: [DateSection] = DateSection.allCases

    typealias ItemInfoType = (section: DateSection, items: [FridgeItem], count: Int)

    typealias ItemInfoArrayType = [ItemInfoType]

    private var itemsBySections: ItemInfoArrayType {
        return self.sections.map { section in
            let filtered = self.items.filter { item in
                section.timeRange.contains(item.expiryDate)
            }
            return (
                section: section,
                items: filtered,
                count: filtered.count
            )
        }
    }

    private var noItems: Bool {
        return self.items.count == 0
    }

    @State var openings: [DateSection: Bool] = DateSection.allCases.reduce(into: [DateSection: Bool]()) { dict, section in
        dict[section] = false
    }

    private func dictBinding(for section: DateSection) -> Binding<Bool> {
        return Binding {
            return self.openings[section]!
        } set: { val in
            self.openings[section] = val
        }
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                Chart(self.itemsBySections, id: \.section) { section, _, count in
                    SectorMark(
                        angle: .value("Count", count),
                        innerRadius: .ratio(0.618),
                        angularInset: 2
                    )
                    .cornerRadius(5)
                    .foregroundStyle(section.color)
                    .foregroundStyle(by: .value("Name", section))
                }
                .chartLegend(position: .bottom, alignment: .center, spacing: 20)
                .chartForegroundStyleScale(
                    domain: self.sections,
                    range: self.sections.map { $0.color }
                )
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
                .padding()

                List {
                    ForEach(self.itemsBySections, id: \.section) { info in
                        Section {
                            CategoryDropdown(info: info, opened: self.dictBinding(for: info.section))

                            if self.openings[info.section]! {
                                ForEach(info.items, id: \.id) { item in
                                    ItemLink(item: item) { _ in
                                    }
                                }
                            } else {
                                EmptyView()
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    PieChartView()
        .modelContainer(previewContainer)
}
