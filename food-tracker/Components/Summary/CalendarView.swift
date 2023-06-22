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

    var visibleItems: [FridgeItem] {
        return items.filter(filteringArchived.filter)
    }

    private typealias ItemInfoType = [Date: [FridgeItem]]

    private var itemsByDates: ItemInfoType {
        return Dictionary(grouping: visibleItems) { item in
            roundDownToDate(date: item.expiryDate)
        }
    }

    private typealias ItemCountTupleType = (date: Date, count: Int)

    private var itemCountByDates: [ItemCountTupleType] {
        return itemsByDates.map { date, items in
            (date: date, count: items.count)
        }
    }

    private var countDomain: ClosedRange<Int> {
        if noItems {
            return 0 ... 0
        } else {
            return 0 ... (
                itemCountByDates.reduce(Int.min) { res, countInfo in
                    max(res, countInfo.count)
                } + 1
            )
        }
    }

    private var dateDomain: ClosedRange<Date> {
        if noItems {
            return Date.now ... Date.now
        } else {
            return (
                itemsByDates.keys.reduce(Date.distantFuture) { partialResult, date in
                    min(partialResult, date)
                } - 3 * SECONDS_IN_A_DAY
            ) ... (
                itemsByDates.keys.reduce(Date.distantPast) { partialResult, date in
                    max(partialResult, date)
                } + 3 * SECONDS_IN_A_DAY
            )
        }
    }

    private var noItems: Bool {
        visibleItems.isEmpty
    }

    @State var filteringArchived: ArchiveFilterStyle = .none

    @State var selectedDate: Date = .now

    var roundedSelectedDate: Date {
        roundDownToDate(date: selectedDate)
    }

    private func selectBar(at location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) {
        let xPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        if let date: Date = proxy.value(atX: xPosition) {
            selectedDate = date
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            SummaryTitle(titleText: "Food Calendar") {
                ItemFilter(filtering: $filteringArchived, text: "Filter Archived")
            }

            List {
                Section {
                    Chart {
                        ForEach(itemCountByDates, id: \.date) { date, count in
                            BarMark(
                                x: .value("Date", date, unit: .day),
                                y: .value("Item Count", count)
                            )
                            .foregroundStyle(date > Date.now ? .green : .red)
                            .cornerRadius(5)
                        }
                    }
                    .frame(height: 200)
                    .chartOverlay { proxy in
                        if noItems {
                            Text("No Items")
                        } else {
                            GeometryReader { geometry in
                                Rectangle()
                                    .fill(.clear)
                                    .contentShape(Rectangle())
                                    .onTapGesture { location in
                                        self.selectBar(at: location, proxy: proxy, geometry: geometry)
                                    }
                            }
                        }
                    }
                    .chartScrollableAxes(.horizontal)
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day)) { value in

                            AxisGridLine()
                            AxisTick()

                            if let date = value.as(Date.self) {
                                let chartDate = Calendar.current.dateComponents([.year, .month, .day], from: date)

                                let currentDate = Calendar.current.dateComponents([.year, .month, .day], from: Date.now)

                                AxisValueLabel(centered: true) {
                                    VStack {
                                        if chartDate == currentDate {
                                            Text("Today")
                                        } else if currentDate.year == chartDate.year {
                                            Text(date, format: .dateTime.month().day())
                                        } else {
                                            Text(date, format: .dateTime.year(.twoDigits).month().day())
                                        }

                                        if Calendar.current.dateComponents([.year, .month, .day], from: roundedSelectedDate) == chartDate {
                                            Circle()
                                                .foregroundStyle(.orange)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .chartXVisibleDomain(length: 5 * SECONDS_IN_A_DAY)
                    .chartYScale(domain: countDomain)
                    .chartXScale(domain: dateDomain)
                    .chartScrollPosition(initialX: Date.now - SECONDS_IN_A_DAY)
                    .chartScrollTargetBehavior(
                        .valueAligned(
                            matching: DateComponents(hour: 0),
                            majorAlignment: .matching(DateComponents(hour: 0))
                        )
                    )
                    .chartYAxisLabel("Food Count")
                    .chartXAxisLabel("Expiry Date")
                }

                Section {
                    Text("On \(selectedDate.formatted(date: .complete, time: .omitted))")

                    if let selectedItems =
                        itemsByDates[roundedSelectedDate]
                    {
                        ForEach(selectedItems) { item in
                            ItemLink(item: item)
                        }
                    } else {
                        Text("Nothing")
                    }
                }
            }
        }
    }
}

#if DEBUG
    #Preview {
        CalendarView()
            .modelContainer(previewContainer)
    }
#endif
