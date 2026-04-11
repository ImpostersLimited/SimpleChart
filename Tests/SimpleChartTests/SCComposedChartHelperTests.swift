import XCTest
import SwiftUI
@testable import SimpleChart

final class SCComposedChartHelperTests: XCTestCase {
    func testScaleHelpersCaptureVisibleDomainAndFixedYRange() {
        let visible = SCChartScale.visible(x: .points(8))
        let fixed = SCChartScale.fixed(y: 10...30)

        XCTAssertEqual(visible.xVisibleDomain, .points(8))
        XCTAssertNil(visible.yDomain)
        XCTAssertEqual(fixed.yDomain?.lowerBound, 10)
        XCTAssertEqual(fixed.yDomain?.upperBound, 30)
    }

    func testOverlayInferredValuesIncludeReferenceLinesBandsAndPointLabels() {
        let referenceLine = SCChartReferenceLine.threshold(12, label: "Goal")
        let band = SCChartBand(title: "Healthy", lower: 8, upper: 16)
        let labels = SCChartPoint.make(values: [3, 9], labels: ["A", "B"])

        XCTAssertEqual(SCChartOverlay.referenceLine(referenceLine).inferredValues, [12])
        XCTAssertEqual(SCChartOverlay.band(band).inferredValues, [8, 16])
        XCTAssertEqual(
            SCChartOverlay.pointLabels(points: labels, color: .blue, anchor: .top).inferredValues,
            [3, 9]
        )
    }

    func testReferenceLineHelpersComputeAverageMinimumAndMaximum() {
        let points = SCChartPoint.make(values: [4, 10, 16], labels: ["A", "B", "C"])

        XCTAssertEqual(SCChartReferenceLine.average(of: points)?.value, 10)
        XCTAssertEqual(SCChartReferenceLine.minimum(of: points)?.value, 4)
        XCTAssertEqual(SCChartReferenceLine.maximum(of: points)?.value, 16)
    }

    func testComposedChartStoresCompositionScaleAndOverlays() {
        let marks: [SCChartMark] = [
            .line(SCChartPoint.make(values: [2, 4, 6])),
            .sector(SCChartSectorSegment.make(segments: [("A", 3), ("B", 5)]))
        ]
        let overlays: [SCChartOverlay] = [
            .referenceLine(.threshold(5, label: "Target")),
            .band(SCChartBand(title: "Healthy", lower: 3, upper: 7))
        ]
        let scale = SCChartScale(
            xVisibleDomain: .points(5),
            yDomain: .fixed(0...10)
        )
        let chart = SCComposedChart(
            composition: SCChartComposition(
                marks: marks,
                overlays: overlays,
                axesStyle: .standard(x: "Month", y: "Value"),
                scale: scale,
                baseZero: true,
                paddingRatio: 0.1
            )
        )

        XCTAssertEqual(chart.marks, marks)
        XCTAssertEqual(chart.overlays, overlays)
        XCTAssertEqual(chart.scale, scale)
        XCTAssertEqual(chart.domain?.upperBound, 10)
        XCTAssertEqual(chart.axesStyle.xLegend, "Month")
        XCTAssertEqual(chart.axesStyle.yLegend, "Value")
        XCTAssertTrue(chart.baseZero)
        XCTAssertEqual(chart.paddingRatio, 0.1)
    }

    func testAxesStyleBridgesToFirstClassAxisHelpers() {
        let axes = SCChartAxesStyle.standard(x: "Month", y: "Revenue", showGrid: true, preferredIntervalCount: 4)

        XCTAssertEqual(axes.xAxis.title, "Month")
        XCTAssertEqual(axes.yAxis.title, "Revenue")
        XCTAssertEqual(axes.xAxis.position, .bottom)
        XCTAssertEqual(axes.yAxis.position, .leading)
        XCTAssertTrue(axes.xAxis.marks.showGrid)
        XCTAssertTrue(axes.yAxis.marks.showLabels)
        XCTAssertEqual(axes.xAxis.marks.desiredCount, 4)
    }

    func testAxisMarksCanStoreExplicitValueSources() {
        let xAxis = SCChartAxis.x(
            title: "Month",
            valueSource: .strings(["Jan", "Feb", "Mar"]),
            showGrid: true
        )
        let yAxis = SCChartAxis.y(
            title: "Revenue",
            valueSource: .doubles([0, 25, 50]),
            showLabels: true
        )

        XCTAssertEqual(xAxis.marks.valueSource, .strings(["Jan", "Feb", "Mar"]))
        XCTAssertEqual(yAxis.marks.valueSource, .doubles([0, 25, 50]))
    }

    func testComposedChartStoresExplicitAxisLegendAndPlotStyleHelpers() {
        let xAxis = SCChartAxis.x(title: "Week", showGrid: true)
        let yAxis = SCChartAxis.y(title: "Users", showLabels: true)
        let legend = SCChartLegend.visible(position: .leading, alignment: .topLeading, spacing: 12)
        let plotStyle = SCChartPlotStyle.card(
            backgroundColor: .blue,
            backgroundOpacity: 0.2,
            cornerRadius: 10,
            padding: 6,
            borderColor: .orange,
            borderWidth: 2
        )
        let chart = SCComposedChart(
            marks: [.line(SCChartPoint.make(values: [2, 4, 6]))],
            xAxis: xAxis,
            yAxis: yAxis,
            legend: legend,
            plotStyle: plotStyle
        )

        XCTAssertEqual(chart.xAxis, xAxis)
        XCTAssertEqual(chart.yAxis, yAxis)
        XCTAssertEqual(chart.legend, legend)
        XCTAssertEqual(chart.plotStyle, plotStyle)
        XCTAssertEqual(chart.legend.position, .leading)
        XCTAssertEqual(chart.legend.alignment, .topLeading)
        XCTAssertEqual(chart.legend.spacing, 12)
        XCTAssertEqual(chart.plotStyle.borderColor, .orange)
        XCTAssertEqual(chart.plotStyle.borderWidth, 2)
    }

    func testComposedChartStoresForegroundStyleScaleHelper() {
        let scale = SCChartForegroundStyleScale.categorical(["Revenue", "Cost"], palette: [.green, .red])
        let chart = SCComposedChart(
            marks: [.line(SCChartPoint.make(values: [2, 4, 6]))],
            foregroundStyleScale: scale
        )

        XCTAssertEqual(chart.foregroundStyleScale, scale)
        XCTAssertEqual(chart.scale.foregroundStyleScale, scale)
    }

    func testThresholdAndGoalChartsStayWrapperFriendlyWithOverlayBackedComposition() {
        let threshold = SCChartReferenceLine.threshold(20, label: "Goal")
        let caution = SCChartReferenceLine.threshold(15, label: "Caution")
        let thresholdChart = SCNativeThresholdChart(values: [8, 13, 18], threshold: threshold)
        let goalChart = SCNativeGoalChart(values: [8, 13, 18], goal: threshold, caution: caution)

        XCTAssertEqual(thresholdChart.threshold.value, 20)
        XCTAssertEqual(thresholdChart.domain?.actualUpperBound, 20)
        XCTAssertEqual(goalChart.goal.value, 20)
        XCTAssertEqual(goalChart.caution?.value, 15)
        XCTAssertEqual(goalChart.domain?.actualUpperBound, 20)
    }

    func testInspectionOverlayCrosshairAndInspectorExposeHelperFlags() {
        let crosshair = SCChartInspectionOverlay.crosshair(anchor: .bottom, showsCallout: false)
        let inspector = SCChartInspectionOverlay.inspector(anchor: .topTrailing)

        XCTAssertTrue(crosshair.showsCrosshair)
        XCTAssertFalse(crosshair.showsCallout)
        XCTAssertEqual(crosshair.anchor, .bottom)
        XCTAssertFalse(inspector.showsCrosshair)
        XCTAssertTrue(inspector.showsCallout)
        XCTAssertEqual(inspector.anchor, .topTrailing)
    }
}
