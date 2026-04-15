import XCTest
import SwiftUI
@testable import SimpleChart

final class SCNativeInteractionAndTimeSeriesTests: XCTestCase {
    func testViewportLengthAndShiftHelpersPreserveWindowSize() {
        let viewport = SCChartViewport.starting(at: 3, length: 5)
        let shifted = viewport.shifted(to: 10)

        XCTAssertEqual(viewport.lowerBound, 3)
        XCTAssertEqual(viewport.upperBound, 8)
        XCTAssertEqual(viewport.length, 5)
        XCTAssertEqual(shifted.lowerBound, 10)
        XCTAssertEqual(shifted.upperBound, 15)
    }

    func testViewportClampAndZoomHelpersStayWithinBounds() {
        let viewport = SCChartViewport(lowerBound: 8, upperBound: 18)
        let clamped = viewport.clamped(to: 0...12)
        let zoomed = viewport.zoomed(by: 2, centeredAt: 10, within: 0...20)

        XCTAssertEqual(clamped.lowerBound, 2)
        XCTAssertEqual(clamped.upperBound, 12)
        XCTAssertEqual(zoomed.lowerBound, 7.5)
        XCTAssertEqual(zoomed.upperBound, 12.5)
    }

    func testVisibleDomainHelpersNormalizeLength() {
        XCTAssertEqual(SCChartVisibleDomain.points(6).length, 6)
        XCTAssertEqual(SCChartVisibleDomain.seconds(3600).length, 3600)
        XCTAssertGreaterThan(SCChartVisibleDomain(length: 0).length, 0)
    }

    func testInteractionHelpersStoreOverlayScrollAndGestureConfiguration() {
        let selectionState = SCChartSelectionState(
            selection: SCChartSelection(seriesName: "Revenue", xLabel: "Jan", value: 42)
        )
        let inspection = SCChartInspectionOverlay.pointLabel(anchor: .bottom)
        let scrollBehavior = SCChartScrollBehavior.timeWindow(seconds: 7200)
        let gestures = SCChartGestureConfiguration(allowsSelection: true, allowsScrolling: false)

        XCTAssertTrue(selectionState.hasSelection)
        XCTAssertEqual(selectionState.selection?.seriesName, "Revenue")
        XCTAssertEqual(inspection.anchor, .bottom)
        XCTAssertFalse(inspection.showsCallout)
        XCTAssertEqual(scrollBehavior.visibleDomain.length, 7200)
        XCTAssertTrue(gestures.allowsSelection)
        XCTAssertFalse(gestures.allowsScrolling)
    }

    func testGestureConfigurationDecodesLegacyPayloadByInferringZoomFromScrolling() throws {
        let scrollingPayload = """
        {"allowsSelection":true,"allowsScrolling":true}
        """.data(using: .utf8)!
        let selectionOnlyPayload = """
        {"allowsSelection":true,"allowsScrolling":false}
        """.data(using: .utf8)!

        let scrollingConfig = try JSONDecoder().decode(
            SCChartGestureConfiguration.self,
            from: scrollingPayload
        )
        let selectionOnlyConfig = try JSONDecoder().decode(
            SCChartGestureConfiguration.self,
            from: selectionOnlyPayload
        )

        XCTAssertTrue(scrollingConfig.allowsZooming)
        XCTAssertFalse(selectionOnlyConfig.allowsZooming)
    }

    func testNumericAndDateFormatsProduceStableText() {
        XCTAssertFalse(SCChartNumericValueFormat.compact.string(from: 12_400).isEmpty)
        XCTAssertTrue(SCChartNumericValueFormat.currency(code: "USD").string(from: 42).contains("$"))

        let date = Date(timeIntervalSince1970: 1_700_000_000)
        XCTAssertFalse(SCChartDateValueFormat.monthDay.string(from: date).isEmpty)
        XCTAssertFalse(SCChartDateValueFormat.hourMinute.string(from: date).isEmpty)
    }

    func testTimeSeriesChartStoresSortedPointsAndFormats() {
        let later = Date(timeIntervalSince1970: 200)
        let earlier = Date(timeIntervalSince1970: 100)
        let chart = SCNativeTimeSeriesChart(
            values: [(later, 8), (earlier, 5)],
            xAxisFormat: .hourMinute,
            yAxisFormat: .compact
        )

        XCTAssertEqual(chart.points.map(\.date), [earlier, later])
        XCTAssertEqual(chart.xAxisFormat, .hourMinute)
        XCTAssertEqual(chart.yAxisFormat, .compact)
        XCTAssertEqual(chart.domain?.actualUpperBound, 8)
    }

    @available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
    func testSelectableWrappersStoreSelectionBindingsAndData() {
        var lineSelection: SCChartSelection?
        var barSelection: SCChartSelection?
        var scatterSelection: SCChartSelection?
        var lineSelectionState = SCChartSelectionState()

        let lineBinding = Binding(get: { lineSelection }, set: { lineSelection = $0 })
        let barBinding = Binding(get: { barSelection }, set: { barSelection = $0 })
        let scatterBinding = Binding(get: { scatterSelection }, set: { scatterSelection = $0 })
        let lineSelectionStateBinding = Binding(
            get: { lineSelectionState },
            set: { lineSelectionState = $0 }
        )

        let lineChart = SCSelectableLineChart(
            points: SCChartPoint.make(labeledValues: [("A", 2), ("B", 4)]),
            selection: lineBinding,
            inspectionOverlay: .callout(anchor: .bottom),
            gestureConfiguration: .interactive
        )
        let barChart = SCSelectableBarChart(
            points: SCChartPoint.make(labeledValues: [("A", 2), ("B", 4)]),
            selection: barBinding,
            inspectionOverlay: .pointLabel(anchor: .topTrailing)
        )
        let scatterChart = SCSelectableScatterChart(
            points: SCChartScatterPoint.make(labeledPoints: [("A", 1.0, 2.0), ("B", 2.0, 4.0)]),
            selection: scatterBinding,
            gestureConfiguration: .selectionOnly
        )
        let lineChartFromState = SCSelectableLineChart(
            points: SCChartPoint.make(labeledValues: [("A", 2), ("B", 4)]),
            selectionState: lineSelectionStateBinding,
            inspectionOverlay: .pointLabel(anchor: .bottom),
            gestureConfiguration: .selectionOnly
        )

        XCTAssertEqual(lineChart.points.count, 2)
        XCTAssertEqual(barChart.points.count, 2)
        XCTAssertEqual(scatterChart.points.count, 2)
        XCTAssertEqual(lineChart.inspectionOverlay, .callout(anchor: .bottom))
        XCTAssertEqual(lineChart.gestureConfiguration, .interactive)
        XCTAssertEqual(barChart.inspectionOverlay, .pointLabel(anchor: .topTrailing))
        XCTAssertEqual(scatterChart.gestureConfiguration, .selectionOnly)
        XCTAssertEqual(lineChartFromState.inspectionOverlay, .pointLabel(anchor: .bottom))
        XCTAssertNil(lineSelection)
        XCTAssertNil(barSelection)
        XCTAssertNil(scatterSelection)
        XCTAssertFalse(lineSelectionState.hasSelection)
    }

    @available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
    func testScrollableWrappersStoreViewportAndFormatting() {
        var viewport = SCChartViewport.starting(at: 0, length: 4)
        let viewportBinding = Binding(get: { viewport }, set: { viewport = $0 })

        let scrollableLine = SCScrollableLineChart(
            points: SCChartPoint.make(labeledValues: [("A", 2), ("B", 4), ("C", 6)]),
            viewport: viewportBinding,
            scrollBehavior: .continuous(.points(4)),
            gestureConfiguration: .interactive,
            yAxisFormat: .percent(precision: 1)
        )

        var scrollPosition = Date(timeIntervalSince1970: 100)
        let timeBinding = Binding(get: { scrollPosition }, set: { scrollPosition = $0 })
        let scrollableTimeSeries = SCScrollableTimeSeriesChart(
            points: SCChartTimePoint.make(values: [
                (Date(timeIntervalSince1970: 100), 2),
                (Date(timeIntervalSince1970: 200), 4)
            ]),
            scrollPosition: timeBinding,
            scrollBehavior: .timeWindow(seconds: 3600),
            xAxisFormat: .time,
            gestureConfiguration: .scrollOnly,
            yAxisFormat: .currency(code: "USD")
        )

        XCTAssertEqual(viewport.lowerBound, 0)
        XCTAssertEqual(viewport.length, 4)
        XCTAssertEqual(scrollableLine.visibleDomain.length, 4)
        XCTAssertEqual(scrollableLine.scrollBehavior.visibleDomain.length, 4)
        XCTAssertEqual(scrollableLine.gestureConfiguration, .interactive)
        XCTAssertEqual(scrollableLine.yAxisFormat, .percent(precision: 1))
        XCTAssertEqual(scrollableTimeSeries.visibleDomain.length, 3600)
        XCTAssertEqual(scrollableTimeSeries.scrollBehavior.visibleDomain.length, 3600)
        XCTAssertEqual(scrollableTimeSeries.gestureConfiguration, .scrollOnly)
        XCTAssertEqual(scrollableTimeSeries.xAxisFormat, .time)
        XCTAssertEqual(scrollableTimeSeries.yAxisFormat, .currency(code: "USD"))
    }
}
