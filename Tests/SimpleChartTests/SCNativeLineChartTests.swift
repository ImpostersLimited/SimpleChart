import XCTest
import SwiftUI
@testable import SimpleChart

final class SCNativeLineChartTests: XCTestCase {
    func testNativeLineChartStoresSharedPointModelAndStyling() {
        let points = [
            SCChartPoint(id: "0", xLabel: "A", value: 1),
            SCChartPoint(id: "1", xLabel: "B", value: 2)
        ]
        let style = SCChartSeriesStyle(
            colors: [.blue, .green],
            strokeWidth: 4,
            showArea: true,
            interpolation: .monotone
        )
        let axes = SCChartAxesStyle(showXAxis: false, showYAxis: true, showGrid: false)
        let domain = SCChartDomain(
            lowerBound: -1,
            upperBound: 8,
            actualLowerBound: 1,
            actualUpperBound: 2
        )

        let chart = SCNativeLineChart(
            points: points,
            seriesStyle: style,
            axesStyle: axes,
            domain: domain
        )

        XCTAssertEqual(chart.points, points)
        XCTAssertEqual(chart.seriesStyle.colors.count, 2)
        XCTAssertEqual(chart.seriesStyle.strokeWidth, 4)
        XCTAssertTrue(chart.seriesStyle.showArea)
        XCTAssertEqual(chart.seriesStyle.interpolation, .monotone)
        XCTAssertFalse(chart.axesStyle.showXAxis)
        XCTAssertTrue(chart.axesStyle.showYAxis)
        XCTAssertEqual(chart.domain?.lowerBound, -1)
        XCTAssertEqual(chart.domain?.upperBound, 8)
    }

    func testNativeLineChartConvenienceInitializerBuildsPointsAndAutoDomain() {
        let referenceLine = SCChartReferenceLine.threshold(5, label: "Goal")
        let chart = SCNativeLineChart(
            values: [2, 5, 3, 7],
            labels: ["Q1", "Q2", "Q3", "Q4"],
            seriesStyle: .area([.blue, .cyan]),
            axesStyle: .standard(x: "Quarter", y: "Revenue"),
            referenceLines: [referenceLine]
        )

        XCTAssertEqual(chart.points.map(\.xLabel), ["Q1", "Q2", "Q3", "Q4"])
        XCTAssertTrue(chart.seriesStyle.showArea)
        XCTAssertEqual(chart.axesStyle.xLegend, "Quarter")
        XCTAssertEqual(chart.axesStyle.yLegend, "Revenue")
        XCTAssertEqual(chart.domain?.actualUpperBound, 7)
        XCTAssertEqual(chart.referenceLines.map(\.title), ["Goal"])
    }
}
