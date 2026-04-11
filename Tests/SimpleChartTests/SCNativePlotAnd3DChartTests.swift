import XCTest
import SwiftUI
@testable import SimpleChart

final class SCNativePlotAnd3DChartTests: XCTestCase {
    func testPlotHelperModelsNormalizeRangesAndRectangles() {
        let ranges = SCChartPlotRange.make(ranges: [(1, 9, 3)])
        let rectangles = SCChartPlotRectangle.make(rectangles: [(5, 2, 8, 1)])
        let spans = SCChartPlotSpan.make(spans: [(7, 3, 4)])

        XCTAssertEqual(ranges[0].yStart, 3)
        XCTAssertEqual(ranges[0].yEnd, 9)
        XCTAssertEqual(rectangles[0].xStart, 2)
        XCTAssertEqual(rectangles[0].xEnd, 5)
        XCTAssertEqual(rectangles[0].yStart, 1)
        XCTAssertEqual(rectangles[0].yEnd, 8)
        XCTAssertEqual(spans[0].xStart, 3)
        XCTAssertEqual(spans[0].xEnd, 7)
    }

    @available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    func testLineAndAreaPlotWrappersStorePointsAndDomains() {
        let points = SCChartPlotPoint.make(
            points: [(0.0, 2.0), (1.0, 4.0), (2.0, 3.0)],
            seriesName: "Revenue"
        )

        let lineChart = SCNativeLinePlotChart(
            points: points,
            seriesStyle: .line([.blue], strokeWidth: 3),
            axesStyle: .standard(x: "Time", y: "Value")
        )
        let areaChart = SCNativeAreaPlotChart(
            points: points,
            seriesStyle: .area([.green]),
            stacking: .normalized
        )

        XCTAssertEqual(lineChart.points, points)
        XCTAssertEqual(lineChart.seriesStyle.strokeWidth, 3)
        XCTAssertEqual(lineChart.axesStyle.xLegend, "Time")
        XCTAssertEqual(lineChart.domain?.actualUpperBound, 4)
        XCTAssertEqual(areaChart.points, points)
        XCTAssertEqual(areaChart.stacking, .normalized)
        XCTAssertEqual(areaChart.domain?.actualLowerBound, 2)
        XCTAssertEqual(areaChart.domain?.actualUpperBound, 4)
    }

    @available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    func testBarPointAndRectanglePlotWrappersStoreConfiguration() {
        let points = SCChartPlotPoint.make(points: [(0.0, 2.0), (1.0, 5.0)])
        let spans = SCChartPlotSpan.make(spans: [(7, 3, 4)])
        let ranges = SCChartPlotRange.make(ranges: [(1, 9, 3)])
        let rectangles = SCChartPlotRectangle.make(rectangles: [(5, 2, 8, 1)])

        let pointBarChart = SCNativeBarPlotChart(
            points: points,
            width: .fixed(10),
            height: .ratio(0.5),
            stacking: .center
        )
        let spanBarChart = SCNativeBarPlotChart(
            spans: spans,
            height: .inset(2)
        )
        let rangeBarChart = SCNativeBarPlotChart(
            ranges: ranges,
            width: .ratio(0.25)
        )
        let pointPlotChart = SCNativePointPlotChart(
            points: points,
            seriesStyle: .scatter([.pink], size: 80)
        )
        let rectanglePlotChart = SCNativeRectanglePlotChart(
            rectangles: rectangles,
            width: .fixed(12),
            height: .ratio(0.4)
        )

        XCTAssertEqual(pointBarChart.points, points)
        XCTAssertEqual(pointBarChart.width, .fixed(10))
        XCTAssertEqual(pointBarChart.height, .ratio(0.5))
        XCTAssertEqual(pointBarChart.stacking, .center)
        XCTAssertEqual(pointBarChart.domain?.lowerBound, 0)
        XCTAssertEqual(pointBarChart.domain?.actualUpperBound, 5)

        XCTAssertEqual(spanBarChart.spans, spans)
        XCTAssertEqual(spanBarChart.height, .inset(2))
        XCTAssertEqual(spanBarChart.domain?.actualUpperBound, 4)

        XCTAssertEqual(rangeBarChart.ranges, ranges)
        XCTAssertEqual(rangeBarChart.width, .ratio(0.25))
        XCTAssertEqual(rangeBarChart.domain?.lowerBound, 0)
        XCTAssertEqual(rangeBarChart.domain?.actualLowerBound, 0)
        XCTAssertEqual(rangeBarChart.domain?.actualUpperBound, 9)

        XCTAssertEqual(pointPlotChart.points, points)
        XCTAssertEqual(pointPlotChart.seriesStyle.markSize, 80)

        XCTAssertEqual(rectanglePlotChart.rectangles, rectangles)
        XCTAssertEqual(rectanglePlotChart.width, .fixed(12))
        XCTAssertEqual(rectanglePlotChart.height, .ratio(0.4))
        XCTAssertEqual(rectanglePlotChart.domain?.actualLowerBound, 1)
        XCTAssertEqual(rectanglePlotChart.domain?.actualUpperBound, 8)
    }

    @available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    func testFunctionPlotWrappersStoreTitlesDomainsAndFunctions() {
        let lineChart = SCNativeFunctionLinePlotChart(
            xTitle: "X",
            yTitle: "Y",
            domain: 0...10
        ) { x in
            x * 2
        }
        let parametricChart = SCNativeParametricLinePlotChart(
            xTitle: "X",
            yTitle: "Y",
            parameterTitle: "t",
            parameterDomain: 0...(.pi)
        ) { t in
            (x: cos(t), y: sin(t))
        }
        let areaChart = SCNativeFunctionAreaPlotChart(
            xTitle: "X",
            yTitle: "Y",
            domain: -1...1
        ) { x in
            x * x
        }
        let bandAreaChart = SCNativeFunctionAreaPlotChart(
            xTitle: "X",
            yStartTitle: "Low",
            yEndTitle: "High",
            domain: 0...5
        ) { x in
            (yStart: x, yEnd: x + 2)
        }

        XCTAssertEqual(lineChart.xTitle, "X")
        XCTAssertEqual(lineChart.yTitle, "Y")
        XCTAssertEqual(lineChart.domain, 0...10)
        XCTAssertEqual(lineChart.function(3), 6)

        XCTAssertEqual(parametricChart.parameterTitle, "t")
        XCTAssertEqual(parametricChart.parameterDomain, 0...(.pi))
        XCTAssertEqual(parametricChart.function(0).x, 1, accuracy: 0.0001)
        XCTAssertEqual(parametricChart.function(0).y, 0, accuracy: 0.0001)

        XCTAssertEqual(areaChart.yTitle, "Y")
        XCTAssertNotNil(areaChart.singleFunction)
        XCTAssertNil(areaChart.bandFunction)
        XCTAssertEqual(areaChart.singleFunction?(3), 9)

        XCTAssertEqual(bandAreaChart.yStartTitle, "Low")
        XCTAssertEqual(bandAreaChart.yEndTitle, "High")
        XCTAssertNil(bandAreaChart.singleFunction)
        XCTAssertEqual(bandAreaChart.bandFunction?(2).yStart, 2)
        XCTAssertEqual(bandAreaChart.bandFunction?(2).yEnd, 4)
    }

    @available(iOS 26.0, macOS 26.0, visionOS 26.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    func test3DHelpersAndWrappersStorePoseStyleAndSeriesConfiguration() {
        let points = SCChart3DPoint.make(points: [(1, 2, 3), (4, 5, 6)], labels: ["A", "B"])
        let style = SCChart3DSeriesStyle(color: .orange, symbolSize: 64)
        let pose = SCChart3DPoseStyle.custom(azimuthDegrees: 35, inclinationDegrees: 25)

        let pointChart = SCNative3DPointChart(points: points, style: style, pose: pose)
        let rectangleChart = SCNative3DRectangleChart(points: points, style: style, pose: .front)
        let ruleChart = SCNative3DRuleChart(points: points, style: style, pose: .top)
        let surfaceChart = SCNativeSurfacePlotChart(
            xTitle: "X",
            yTitle: "Y",
            zTitle: "Z",
            style: style,
            pose: pose
        ) { x, y in
            x + y
        }

        XCTAssertEqual(points.map(\.label), ["A", "B"])
        XCTAssertEqual(style.symbolSize, 64)
        XCTAssertEqual(pose, .custom(azimuthDegrees: 35, inclinationDegrees: 25))

        XCTAssertEqual(pointChart.points, points)
        XCTAssertEqual(pointChart.style, style)
        XCTAssertEqual(pointChart.pose, pose)

        XCTAssertEqual(rectangleChart.points, points)
        XCTAssertEqual(rectangleChart.pose, .front)

        XCTAssertEqual(ruleChart.points, points)
        XCTAssertEqual(ruleChart.pose, .top)

        XCTAssertEqual(surfaceChart.xTitle, "X")
        XCTAssertEqual(surfaceChart.yTitle, "Y")
        XCTAssertEqual(surfaceChart.zTitle, "Z")
        XCTAssertEqual(surfaceChart.style, style)
        XCTAssertEqual(surfaceChart.pose, pose)
        XCTAssertEqual(surfaceChart.function(2, 3), 5)
    }
}
