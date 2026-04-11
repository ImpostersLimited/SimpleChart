import XCTest
import SwiftUI
@testable import SimpleChart

final class SCNativeExtendedChartTests: XCTestCase {
    func testScatterBuilderAndChartConvenienceKeepLabelsAndAutoDomain() {
        let points = SCChartScatterPoint.make(
            labeledPoints: [("A", 1.5, 2.5), ("B", 3.0, 4.5)]
        )
        let chart = SCNativeScatterChart(labeledPoints: [("A", 1.5, 2.5), ("B", 3.0, 4.5)])

        XCTAssertEqual(points.map(\.label), ["A", "B"])
        XCTAssertEqual(chart.points, points)
        XCTAssertEqual(chart.domain?.actualUpperBound, 4.5)
    }

    func testSectorBuilderAppliesOptionalColorsAndValues() {
        let segments = SCChartSectorSegment.make(
            segments: [("Alpha", 2), ("Beta", 5)],
            colors: [.red]
        )

        XCTAssertEqual(segments.map(\.title), ["Alpha", "Beta"])
        XCTAssertEqual(segments.map(\.value), [2, 5])
        XCTAssertEqual(segments[0].color, .red)
        XCTAssertNil(segments[1].color)
    }

    func testGroupedBarChartConvenienceBuildsGroupsAndAutoDomain() {
        let chart = SCNativeGroupedBarChart(
            groups: [
                ("Q1", [("Revenue", 10), ("Cost", 4)]),
                ("Q2", [("Revenue", 12), ("Cost", 6)])
            ]
        )

        XCTAssertEqual(chart.groups.map(\.category), ["Q1", "Q2"])
        XCTAssertEqual(chart.groups[0].entries.map(\.series), ["Revenue", "Cost"])
        XCTAssertEqual(chart.domain?.lowerBound, 0)
        XCTAssertEqual(chart.domain?.actualUpperBound, 12)
        XCTAssertEqual(chart.legend.position, .bottom)
        XCTAssertEqual(chart.foregroundStyleScale.domain, ["Cost", "Revenue"])
    }

    func testStackedBarChartConvenienceBuildsSegmentsAndTotalsDomain() {
        let chart = SCNativeStackedBarChart(
            groups: [
                ("Q1", [("Revenue", 10), ("Cost", 4)]),
                ("Q2", [("Revenue", 12), ("Cost", 6)])
            ]
        )

        XCTAssertEqual(chart.segments.count, 4)
        XCTAssertEqual(chart.domain?.lowerBound, 0)
        XCTAssertEqual(chart.domain?.actualUpperBound, 18)
        XCTAssertEqual(chart.legend.position, .bottom)
        XCTAssertEqual(chart.foregroundStyleScale.domain, ["Cost", "Revenue"])
    }

    func testThresholdChartConvenienceIncludesThresholdInAutoDomain() {
        let threshold = SCChartReferenceLine.threshold(20, label: "Goal")
        let chart = SCNativeThresholdChart(
            values: [8, 13, 18],
            labels: ["A", "B", "C"],
            threshold: threshold
        )

        XCTAssertEqual(chart.points.map(\.xLabel), ["A", "B", "C"])
        XCTAssertEqual(chart.threshold.title, "Goal")
        XCTAssertEqual(chart.domain?.actualUpperBound, 20)
    }

    func testGoalChartConvenienceIncludesGoalAndCautionInAutoDomain() {
        let goal = SCChartReferenceLine.threshold(25, label: "Goal")
        let caution = SCChartReferenceLine.threshold(20, label: "Caution")
        let chart = SCNativeGoalChart(
            values: [8, 13, 18],
            labels: ["A", "B", "C"],
            goal: goal,
            caution: caution
        )

        XCTAssertEqual(chart.points.map(\.xLabel), ["A", "B", "C"])
        XCTAssertEqual(chart.goal.value, 25)
        XCTAssertEqual(chart.caution?.value, 20)
        XCTAssertEqual(chart.domain?.actualUpperBound, 25)
    }

    func testComposedChartStoresMarksAndConfiguration() {
        let marks: [SCChartMark] = [
            .line(SCChartPoint.make(values: [2, 4, 6])),
            .rule(.threshold(5, label: "Target"))
        ]
        let chart = SCComposedChart(
            marks: marks,
            axesStyle: .standard(x: "Month", y: "Value"),
            baseZero: true,
            paddingRatio: 0.1
        )

        XCTAssertEqual(chart.marks, marks)
        XCTAssertTrue(chart.baseZero)
        XCTAssertEqual(chart.paddingRatio, 0.1)
        XCTAssertEqual(chart.axesStyle.xLegend, "Month")
        XCTAssertEqual(chart.axesStyle.yLegend, "Value")
    }

    func testGroupedAreaChartConvenienceBuildsLegendAndForegroundScale() {
        let chart = SCNativeGroupedAreaChart(
            series: [
                SCChartLineSeries.make(name: "Revenue", values: [10, 12], labels: ["Q1", "Q2"], style: .area([.green])),
                SCChartLineSeries.make(name: "Cost", values: [4, 6], labels: ["Q1", "Q2"], style: .area([.red]))
            ]
        )

        XCTAssertEqual(chart.series.map(\.name), ["Revenue", "Cost"])
        XCTAssertEqual(chart.legend.position, .bottom)
        XCTAssertEqual(chart.foregroundStyleScale.domain, ["Revenue", "Cost"])
        XCTAssertEqual(chart.domain?.actualUpperBound, 12)
    }

    func testStackedAreaChartConvenienceUsesCumulativeDomain() {
        let chart = SCNativeStackedAreaChart(
            series: [
                SCChartLineSeries.make(name: "Revenue", values: [10, 12], labels: ["Q1", "Q2"], style: .area([.green])),
                SCChartLineSeries.make(name: "Cost", values: [4, 6], labels: ["Q1", "Q2"], style: .area([.red]))
            ]
        )

        XCTAssertEqual(chart.legend.position, .bottom)
        XCTAssertEqual(chart.foregroundStyleScale.domain, ["Revenue", "Cost"])
        XCTAssertEqual(chart.domain?.lowerBound, 0)
        XCTAssertEqual(chart.domain?.actualUpperBound, 18)
    }

    @available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
    func testSectorAndDonutConvenienceBuildSegments() {
        let sector = SCNativeSectorChart(segments: [("A", 2), ("B", 3)])
        let donut = SCNativeDonutChart(segments: [("A", 2), ("B", 3)], innerRadiusRatio: 0.5)

        XCTAssertEqual(sector.segments.map(\.title), ["A", "B"])
        XCTAssertEqual(donut.segments.map(\.value), [2, 3])
        XCTAssertEqual(donut.innerRadiusRatio, 0.5)
    }
}
