import XCTest
import SwiftUI
@testable import SimpleChart

final class SCInspectionWrapperTests: XCTestCase {
    func testVisibleDomainAndScrollBehaviorPresetsExpandToExpectedLengths() {
        XCTAssertEqual(SCChartVisibleDomain.minutes(15).length, 900)
        XCTAssertEqual(SCChartVisibleDomain.hours(2).length, 7_200)
        XCTAssertEqual(SCChartVisibleDomain.days(3).length, 259_200)
        XCTAssertEqual(SCChartVisibleDomain.weeks(2).length, 1_209_600)
        XCTAssertEqual(SCChartVisibleDomain.analytics(points: 21).length, 21)
        XCTAssertEqual(SCChartVisibleDomain.finance(tradingDays: 10).length, 10)

        XCTAssertEqual(SCChartScrollBehavior.timeWindow(minutes: 30).visibleDomain.length, 1_800)
        XCTAssertEqual(SCChartScrollBehavior.timeWindow(hours: 6).visibleDomain.length, 21_600)
        XCTAssertEqual(SCChartScrollBehavior.timeWindow(days: 2).visibleDomain.length, 172_800)
        XCTAssertEqual(SCChartScrollBehavior.analytics(points: 28).visibleDomain.length, 28)
        XCTAssertEqual(SCChartScrollBehavior.finance(tradingDays: 20).visibleDomain.length, 20)
    }

    @available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
    func testSelectableTimeSeriesChartStoresInspectionAndFormattingState() {
        var selection: SCChartSelection?
        let selectionBinding = Binding(get: { selection }, set: { selection = $0 })
        let points = SCChartTimePoint.make(values: [
            (Date(timeIntervalSince1970: 100), 2),
            (Date(timeIntervalSince1970: 200), 4)
        ])

        let chart = SCSelectableTimeSeriesChart(
            points: points,
            selection: selectionBinding,
            inspectionOverlay: .crosshair(anchor: .bottom, showsCallout: false),
            gestureConfiguration: .interactive,
            xAxisFormat: .hourMinute,
            yAxisFormat: .currency(code: "USD")
        )

        XCTAssertEqual(chart.points, points)
        XCTAssertEqual(chart.inspectionOverlay, .crosshair(anchor: .bottom, showsCallout: false))
        XCTAssertEqual(chart.gestureConfiguration, .interactive)
        XCTAssertEqual(chart.xAxisFormat, .hourMinute)
        XCTAssertEqual(chart.yAxisFormat, .currency(code: "USD"))
        XCTAssertNil(selection)
    }

    @available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
    func testInspectorAndCrosshairWrappersExposeExpectedDefaults() {
        var selection: SCChartSelection?
        let selectionBinding = Binding(get: { selection }, set: { selection = $0 })

        let linePoints = SCChartPoint.make(labeledValues: [("Mon", 12), ("Tue", 18)])
        let scatterPoints = SCChartScatterPoint.make(labeledPoints: [("A", 1.5, 2.5), ("B", 3.0, 4.0)])
        let timePoints = SCChartTimePoint.make(values: [
            (Date(timeIntervalSince1970: 100), 3),
            (Date(timeIntervalSince1970: 200), 5)
        ])

        let inspectorLine = SCInspectorLineChart(points: linePoints, selection: selectionBinding)
        let crosshairBar = SCCrosshairBarChart(points: linePoints, selection: selectionBinding, showsCallout: false)
        let inspectorScatter = SCInspectorScatterChart(points: scatterPoints, selection: selectionBinding, anchor: .bottomTrailing)
        let crosshairTimeSeries = SCCrosshairTimeSeriesChart(
            points: timePoints,
            selection: selectionBinding,
            anchor: .topLeading,
            xAxisFormat: .time
        )

        XCTAssertEqual(inspectorLine.points, linePoints)
        XCTAssertEqual(inspectorLine.anchor, .top)
        XCTAssertEqual(inspectorLine.gestureConfiguration, .selectionOnly)

        XCTAssertEqual(crosshairBar.points, linePoints)
        XCTAssertEqual(crosshairBar.showsCallout, false)
        XCTAssertEqual(crosshairBar.anchor, .top)

        XCTAssertEqual(inspectorScatter.points, scatterPoints)
        XCTAssertEqual(inspectorScatter.anchor, .bottomTrailing)

        XCTAssertEqual(crosshairTimeSeries.points, timePoints)
        XCTAssertEqual(crosshairTimeSeries.anchor, .topLeading)
        XCTAssertEqual(crosshairTimeSeries.xAxisFormat, .time)
        XCTAssertTrue(crosshairTimeSeries.showsCallout)
    }
}
