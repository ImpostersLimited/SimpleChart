import XCTest
import SwiftUI
@testable import SimpleChart

final class SCChartZoomNavigationTests: XCTestCase {
    func testTimeViewportLengthShiftClampAndZoomHelpersPreserveExpectedWindow() {
        let start = Date(timeIntervalSince1970: 100)
        let viewport = SCChartTimeViewport.starting(at: start, duration: 60)
        let shifted = viewport.shifted(to: Date(timeIntervalSince1970: 150))
        let clamped = SCChartTimeViewport(
            startDate: Date(timeIntervalSince1970: 180),
            endDate: Date(timeIntervalSince1970: 300)
        )
        .clamped(to: Date(timeIntervalSince1970: 120)...Date(timeIntervalSince1970: 240))
        let zoomed = viewport.zoomed(
            by: 2,
            centeredAt: Date(timeIntervalSince1970: 130),
            within: Date(timeIntervalSince1970: 90)...Date(timeIntervalSince1970: 240)
        )

        XCTAssertEqual(viewport.length, 60, accuracy: 0.0001)
        XCTAssertEqual(shifted.startDate.timeIntervalSince1970, 150, accuracy: 0.0001)
        XCTAssertEqual(shifted.endDate.timeIntervalSince1970, 210, accuracy: 0.0001)
        XCTAssertEqual(clamped.startDate.timeIntervalSince1970, 120, accuracy: 0.0001)
        XCTAssertEqual(clamped.endDate.timeIntervalSince1970, 240, accuracy: 0.0001)
        XCTAssertEqual(zoomed.startDate.timeIntervalSince1970, 115, accuracy: 0.0001)
        XCTAssertEqual(zoomed.endDate.timeIntervalSince1970, 145, accuracy: 0.0001)
    }

    func testZoomBehaviorAndGestureConfigurationStoreZoomSupport() {
        let zoomBehavior = SCChartZoomBehavior(
            minimumVisibleLength: 2,
            maximumVisibleLength: 12,
            sensitivity: 0.5
        )
        let gestures = SCChartGestureConfiguration(
            allowsSelection: true,
            allowsScrolling: true,
            allowsZooming: true
        )

        XCTAssertTrue(zoomBehavior.isEnabled)
        XCTAssertEqual(zoomBehavior.minimumVisibleLength, 2)
        XCTAssertEqual(zoomBehavior.maximumVisibleLength, 12)
        XCTAssertEqual(zoomBehavior.sensitivity, 0.5)
        XCTAssertTrue(gestures.allowsZooming)
        XCTAssertTrue(SCChartGestureConfiguration.interactive.allowsZooming)
        XCTAssertTrue(SCChartGestureConfiguration.scrollOnly.allowsZooming)
        XCTAssertFalse(SCChartGestureConfiguration.selectionOnly.allowsZooming)
    }

    func testNavigationCoordinatorClampsIndexedViewportWithinBoundsAndZoomLimits() {
        let viewport = SCChartViewport.starting(at: 8, length: 10)
        let clamped = SCChartNavigationCoordinator.clampedViewport(
            viewport,
            zoomBehavior: SCChartZoomBehavior(minimumVisibleLength: 3, maximumVisibleLength: 6),
            bounds: 0...12
        )

        XCTAssertEqual(clamped.lowerBound, 6, accuracy: 0.0001)
        XCTAssertEqual(clamped.upperBound, 12, accuracy: 0.0001)
        XCTAssertEqual(clamped.length, 6, accuracy: 0.0001)
    }

    func testNavigationCoordinatorClampsTimeViewportWithinBoundsAndZoomLimits() {
        let viewport = SCChartTimeViewport(
            startDate: Date(timeIntervalSince1970: 180),
            endDate: Date(timeIntervalSince1970: 320)
        )
        let clamped = SCChartNavigationCoordinator.clampedViewport(
            viewport,
            zoomBehavior: SCChartZoomBehavior(minimumVisibleLength: 60, maximumVisibleLength: 120),
            bounds: Date(timeIntervalSince1970: 100)...Date(timeIntervalSince1970: 240)
        )

        XCTAssertEqual(clamped.startDate.timeIntervalSince1970, 120, accuracy: 0.0001)
        XCTAssertEqual(clamped.endDate.timeIntervalSince1970, 240, accuracy: 0.0001)
        XCTAssertEqual(clamped.length, 120, accuracy: 0.0001)
    }

    @available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
    func testScrollableWrappersStoreZoomBehaviorAndViewportBindings() {
        var indexedViewport = SCChartViewport.starting(at: 0, length: 6)
        let indexedBinding = Binding(get: { indexedViewport }, set: { indexedViewport = $0 })
        let indexedChart = SCScrollableLineChart(
            points: SCChartPoint.make(labeledValues: [("A", 2), ("B", 4), ("C", 6), ("D", 8)]),
            viewport: indexedBinding,
            scrollBehavior: .continuous(.points(6)),
            zoomBehavior: SCChartZoomBehavior(minimumVisibleLength: 2, maximumVisibleLength: 6),
            gestureConfiguration: .interactive
        )

        var timeViewport = SCChartTimeViewport.starting(
            at: Date(timeIntervalSince1970: 100),
            duration: 3600
        )
        let timeBinding = Binding(get: { timeViewport }, set: { timeViewport = $0 })
        let timeChart = SCScrollableTimeSeriesChart(
            points: SCChartTimePoint.make(values: [
                (Date(timeIntervalSince1970: 100), 2),
                (Date(timeIntervalSince1970: 200), 4),
                (Date(timeIntervalSince1970: 300), 6)
            ]),
            viewport: timeBinding,
            scrollBehavior: .timeWindow(seconds: 3600),
            zoomBehavior: SCChartZoomBehavior(minimumVisibleLength: 900, maximumVisibleLength: 7200),
            gestureConfiguration: .scrollOnly
        )

        XCTAssertEqual(indexedChart.zoomBehavior.minimumVisibleLength, 2)
        XCTAssertEqual(indexedChart.zoomBehavior.maximumVisibleLength, 6)
        XCTAssertTrue(indexedChart.gestureConfiguration.allowsZooming)
        XCTAssertEqual(timeChart.zoomBehavior.minimumVisibleLength, 900)
        XCTAssertEqual(timeChart.zoomBehavior.maximumVisibleLength, 7200)
        XCTAssertTrue(timeChart.gestureConfiguration.allowsZooming)
        XCTAssertEqual(indexedViewport.length, 6, accuracy: 0.0001)
        XCTAssertEqual(timeViewport.length, 3600, accuracy: 0.0001)
    }

    @available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
    func testScrollableLineChartInitiallyRendersConfiguredVisibleDomainBeforeViewportTakesOver() {
        var viewport = SCChartViewport.starting(at: 1, length: 3)
        let binding = Binding(get: { viewport }, set: { viewport = $0 })
        let chart = SCScrollableLineChart(
            points: SCChartPoint.make(labeledValues: [
                ("A", 2),
                ("B", 4),
                ("C", 6),
                ("D", 8),
                ("E", 10),
                ("F", 12)
            ]),
            viewport: binding,
            visibleDomain: .points(6),
            zoomBehavior: .standard,
            gestureConfiguration: .interactive
        )

        XCTAssertEqual(chart.visibleDomain.length, 6, accuracy: 0.0001)
        XCTAssertEqual(chart.renderedVisibleDomain.length, 6, accuracy: 0.0001)
    }

    @available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
    func testScrollableTimeSeriesChartLegacyScrollPositionPreservesConfiguredWindowLength() {
        var scrollPosition = Date(timeIntervalSince1970: 100)
        let binding = Binding(get: { scrollPosition }, set: { scrollPosition = $0 })
        let chart = SCScrollableTimeSeriesChart(
            points: SCChartTimePoint.make(values: [
                (Date(timeIntervalSince1970: 100), 2),
                (Date(timeIntervalSince1970: 130), 4),
                (Date(timeIntervalSince1970: 160), 6)
            ]),
            scrollPosition: binding,
            visibleDomain: .seconds(300),
            gestureConfiguration: .scrollOnly
        )

        XCTAssertEqual(chart.visibleDomain.length, 300, accuracy: 0.0001)
        XCTAssertEqual(chart.renderedVisibleDomain.length, 300, accuracy: 0.0001)
    }
}
