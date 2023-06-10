//
//  CalendarView.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/9/23.
//

import Charts
import SwiftUI

#if DEBUG
    import SwiftData
#endif

struct CalendarView: View {
    #if DEBUG
        @Query var items: [FridgeItem]
    #else
        var items: [FridgeItem]
    #endif

    private typealias ItemInfoType = [Date: [FridgeItem]]

    private var itemsByDates: ItemInfoType {
        return Dictionary(grouping: items) { item in
            roundDownToDate(date: item.expiryDate)
        }
    }

    private typealias ItemCountTupleType = (date: Date, count: Int)

    private var itemCountByDates: [ItemCountTupleType] {
        return itemsByDates.map { date, items in
            (date: date, count: items.count)
        }
    }

    private var maxCount: Int {
        return itemCountByDates.reduce(Int.min) { res, countInfo in
            max(res, countInfo.count)
        }
    }

    @State var scrollPosition: Date = .now

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Food Calendar")
                        .font(.title)
                        .bold()
                    Text("As for \(Date.now.formatted(date: .abbreviated, time: .omitted))")
                }
                .padding(.leading, 20)

                Chart {
                    ForEach(itemCountByDates, id: \.date) { date, count in
                        BarMark(
                            x: .value("Date", date, unit: .day),
                            y: .value("Item Count", count)
                        )
                        .foregroundStyle(date > Date.now ? .green : .red)
                    }

                    RuleMark(x: .value("Today", Date.now, unit: .day))
                        .foregroundStyle(.yellow)
                        .offset(yStart: -10)
                        .annotation(
                            position: .top,
                            spacing: 0,
                            overflowResolution: .init(
                                x: .fit(to: .chart),
                                y: .disabled
                            )
                        ) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(width: 30, height: 20)
                                Text("Now")
                            }
                        }
                }
                .chartScrollableAxes(.horizontal)
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day))
                }
                .chartXVisibleDomain(length: 7 * SECONDS_IN_A_DAY)
                .chartYScale(domain: 0 ... (maxCount + 1))
                .frame(maxHeight: geometry.size.width)
                .chartScrollPosition(initialX: Date.now - SECONDS_IN_A_DAY)
                .chartScrollPosition(x: $scrollPosition)
                .chartScrollTargetBehavior(
                    .valueAligned(
                        matching: DateComponents(hour: 0),
                        majorAlignment: .matching(DateComponents(hour: 0))
                    )
                )
                .chartYAxisLabel("Food Count")
                .chartXAxisLabel("Expiry Date")
                .padding()

                Text("\(scrollPosition)")
            }
        }
    }
}

#Preview {
    CalendarView()
        .modelContainer(previewContainer)
}
