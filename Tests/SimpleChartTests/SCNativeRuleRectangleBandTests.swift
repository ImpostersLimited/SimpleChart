import XCTest
import SwiftUI
@testable import SimpleChart

final class SCNativeRuleRectangleBandTests: XCTestCase {
    func testRectangleBuilderNormalizesRangesAndPreservesOptionalColors() {
        let rectangles = SCChartRectangle.make(
            rectangles: [(4, 1, 10, 6), (2, 3, 5, 8)],
            colors: [.red]
        )

        XCTAssertEqual(rectangles.count, 2)
        XCTAssertEqual(rectangles[0].xStart, 1)
        XCTAssertEqual(rectangles[0].xEnd, 4)
        XCTAssertEqual(rectangles[0].yStart, 6)
        XCTAssertEqual(rectangles[0].yEnd, 10)
        XCTAssertEqual(rectangles[0].color, .red)
        XCTAssertNil(rectangles[1].color)
    }

    func testRectangleChartConvenienceBuildsRectanglesAndAutoDomain() {
        let chart = SCNativeRectangleChart(
            rectangles: [(0, 2, 3, 9), (2, 4, 1, 5)],
            colors: [.orange, .blue]
        )

        XCTAssertEqual(chart.rectangles.count, 2)
        XCTAssertEqual(chart.rectangles[0].xEnd, 2)
        XCTAssertEqual(chart.rectangles[0].yEnd, 9)
        XCTAssertEqual(chart.domain?.actualUpperBound, 9)
    }

    func testRuleChartConvenienceIncludesReferenceValuesInAutoDomain() {
        let caution = SCChartReferenceLine.threshold(12, label: "Caution", color: .yellow)
        let goal = SCChartReferenceLine.threshold(20, label: "Goal", color: .red)
        let chart = SCNativeRuleChart(referenceLines: [caution, goal], baseZero: true)

        XCTAssertEqual(chart.referenceLines.map(\.title), ["Caution", "Goal"])
        XCTAssertEqual(chart.domain?.lowerBound, 0)
        XCTAssertEqual(chart.domain?.actualUpperBound, 20)
    }

    func testBandBuildersAndChartConvenienceNormalizeAndStoreCategories() {
        let bands = SCChartBand.make(
            bands: [("Healthy", 15, 5), ("Stretch", 20, 30)],
            color: .green,
            opacity: 0.2
        )
        let chart = SCNativeBandChart(
            categories: ["Mon", "Tue", "Wed"],
            bands: [("Healthy", 15, 5), ("Stretch", 20, 30)],
            color: .green,
            opacity: 0.2
        )

        XCTAssertEqual(bands[0].lower, 5)
        XCTAssertEqual(bands[0].upper, 15)
        XCTAssertEqual(chart.categories, ["Mon", "Tue", "Wed"])
        XCTAssertEqual(chart.bands.map(\.title), ["Healthy", "Stretch"])
        XCTAssertEqual(chart.domain?.actualUpperBound, 30)
    }

    func testComposedChartStoresRectangleMarks() {
        let rectangles = SCChartRectangle.make(rectangles: [(0, 1, 2, 4), (1, 2, 4, 6)])
        let marks: [SCChartMark] = [.rectangle(rectangles, style: .bar([.mint]))]
        let chart = SCComposedChart(marks: marks)

        XCTAssertEqual(chart.marks, marks)
        XCTAssertNil(chart.domain)
        XCTAssertEqual(chart.marks.flatMap(\.inferredValues).max(), 6)
    }
}
