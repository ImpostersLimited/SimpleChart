import XCTest
import SwiftUI
@testable import SimpleChart

final class SCNativeBarAndRangeChartTests: XCTestCase {
    func testNativeBarChartStoresPointsAndDomain() {
        let points = [
            SCChartPoint(id: "0", xLabel: "A", value: 3)
        ]
        let domain = SCChartDomain(
            lowerBound: 0,
            upperBound: 10,
            actualLowerBound: 3,
            actualUpperBound: 3
        )

        let chart = SCNativeBarChart(points: points, domain: domain)

        XCTAssertEqual(chart.points, points)
        XCTAssertEqual(chart.domain?.lowerBound, 0)
        XCTAssertEqual(chart.domain?.upperBound, 10)
    }

    func testNativeRangeChartStoresPointsAndStrokeOnlyStyle() {
        let points = [
            SCChartRangePoint(id: "0", xLabel: "A", lower: 1, upper: 4)
        ]
        let style = SCChartSeriesStyle(colors: [.pink], strokeWidth: 3, strokeOnly: true)
        let chart = SCNativeRangeChart(points: points, seriesStyle: style)

        XCTAssertEqual(chart.points, points)
        XCTAssertTrue(chart.seriesStyle.strokeOnly)
        XCTAssertEqual(chart.seriesStyle.strokeWidth, 3)
    }

    func testNativeBarChartConvenienceInitializerBuildsAutoDomain() {
        let chart = SCNativeBarChart(
            labeledValues: [("A", 3), ("B", 7)],
            axesStyle: .standard(x: "Bucket", y: "Count")
        )

        XCTAssertEqual(chart.points.map(\.xLabel), ["A", "B"])
        XCTAssertEqual(chart.domain?.lowerBound, 0)
        XCTAssertEqual(chart.domain?.actualUpperBound, 7)
    }

    func testNativeRangeChartConvenienceInitializerBuildsPointsAndDomain() {
        let chart = SCNativeRangeChart(
            labeledRanges: [("Mon", 9, 1), ("Tue", 3, 5)],
            seriesStyle: .rangeStroke([.pink], width: 4)
        )

        XCTAssertEqual(chart.points.map(\.xLabel), ["Mon", "Tue"])
        XCTAssertEqual(chart.points[0].lower, 1)
        XCTAssertEqual(chart.points[0].upper, 9)
        XCTAssertTrue(chart.seriesStyle.strokeOnly)
        XCTAssertEqual(chart.domain?.actualUpperBound, 9)
    }
}
