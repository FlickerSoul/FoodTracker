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
        if filteringArchived {
            return items.filter { !$0.archived }
        } else {
            return items
        }
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
        return 0 ... (
            itemCountByDates.reduce(Int.min) { res, countInfo in
                max(res, countInfo.count)
            } + 1
        )
    }

    private var dateDomain: ClosedRange<Date> {
        (
            itemsByDates.keys.reduce(Date.distantFuture) { partialResult, date in
                min(partialResult, date)
            } - 3 * SECONDS_IN_A_DAY
        ) ... (
            itemsByDates.keys.reduce(Date.distantPast) { partialResult, date in
                max(partialResult, date)
            } + 3 * SECONDS_IN_A_DAY
        )
    }

    @State var filteringArchived: Bool = true

    @State var selectedDate: Date? = nil

    private func selectBar(at location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) {
        let xPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        if let date: Date = proxy.value(atX: xPosition) {
            selectedDate = date
        } else {
            selectedDate = nil
        }
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Food Calendar")
                            .font(.title)
                            .bold()
                        Text("As for \(Date.now.formatted(date: .abbreviated, time: .omitted))")
                    }

                    Spacer()

                    ItemFilter(filtering: $filteringArchived, text: "Filter Archived")
                }
                .padding(.horizontal)

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
                .chartOverlay { proxy in
                    GeometryReader { geometry in
                        Rectangle()
                            .fill(.clear)
                            .contentShape(Rectangle())
                            .onTapGesture { location in
                                self.selectBar(at: location, proxy: proxy, geometry: geometry)
                            }
                    }
                }
                .chartScrollableAxes(.horizontal)
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day))
                }
                .chartXVisibleDomain(length: 7 * SECONDS_IN_A_DAY)
                .chartYScale(domain: countDomain)
                .chartXScale(domain: dateDomain)
                .frame(maxHeight: geometry.size.width)
                .chartScrollPosition(initialX: Date.now - SECONDS_IN_A_DAY)
                .chartScrollTargetBehavior(
                    .valueAligned(
                        matching: DateComponents(hour: 0),
                        majorAlignment: .matching(DateComponents(day: 0))
                    )
                )
                .chartYAxisLabel("Food Count")
                .chartXAxisLabel("Expiry Date")
                .padding(.horizontal)

                List {
                    if let selectedDate = selectedDate {
                        let rounded = roundDownToDate(date: selectedDate)

                        Text("On \(selectedDate.formatted(date: .complete, time: .omitted))")

                        if let selectedItems =
                            itemsByDates[rounded]
                        {
                            ForEach(selectedItems) { item in
                                ItemLink(item: item) { _ in
                                }
                            }
                        } else {
                            Text("Nothing")
                        }
                    } else {
                        Text("No Date Selected")
                    }
                }
            }
        }
    }
}

#Preview {
    CalendarView()
        .modelContainer(previewContainer)
}
