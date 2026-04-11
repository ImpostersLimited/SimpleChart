import XCTest
import SwiftUI
@testable import SimpleChart

final class SCLegacyBridgeTests: XCTestCase {
    func testLegacyLineConfigMapsToNativeDomainAxesAndAreaStyle() {
        let config = SCLineChartConfig(
            chartData: [SCLineChartData(2), SCLineChartData(4)],
            baseZero: true,
            showInterval: true,
            showXAxis: true,
            showYAxis: true,
            showYAxisFigure: true,
            stroke: false,
            strokeWidth: 2,
            color: [.red, .blue],
            numOfInterval: 5,
            xLegend: "X",
            yLegend: "Y",
            xLegendColor: .green,
            yLegendColor: .orange,
            gradientStart: .leading,
            gradientEnd: .trailing,
            yAxisFigureColor: .purple,
            yAxisFigureFontFactor: 0.25
        )

        XCTAssertEqual(config.chartData.scNativePoints.map(\.value), [2, 4])
        XCTAssertEqual(config.scNativeAxesStyle.preferredIntervalCount, 5)
        XCTAssertTrue(config.scNativeAxesStyle.showXAxis)
        XCTAssertTrue(config.scNativeAxesStyle.showYAxis)
        XCTAssertTrue(config.scNativeAxesStyle.showGrid)
        XCTAssertTrue(config.scNativeAxesStyle.showYAxisLabels)
        XCTAssertEqual(config.scNativeAxesStyle.xLegend, "X")
        XCTAssertEqual(config.scNativeAxesStyle.yLegend, "Y")

        XCTAssertEqual(config.scNativeSeriesStyle.colors, [.red, .blue])
        XCTAssertEqual(config.scNativeSeriesStyle.strokeWidth, 2)
        XCTAssertTrue(config.scNativeSeriesStyle.showArea)
        XCTAssertFalse(config.scNativeSeriesStyle.strokeOnly)
        XCTAssertEqual(config.scNativeSeriesStyle.interpolation, .linear)

        XCTAssertEqual(config.scNativeDomain.lowerBound, 0, accuracy: 0.0001)
        XCTAssertEqual(config.scNativeDomain.upperBound, 4.06, accuracy: 0.0001)
        XCTAssertEqual(config.scNativeDomain.actualLowerBound, 0, accuracy: 0.0001)
        XCTAssertEqual(config.scNativeDomain.actualUpperBound, 4, accuracy: 0.0001)
    }

    func testLegacyQuadCurveConfigMapsToCatmullRomStrokeStyle() {
        let config = SCQuadCurveConfig(
            chartData: [SCQuadCurveData(1), SCQuadCurveData(3)],
            stroke: true,
            strokeWidth: 4,
            color: [.mint]
        )

        XCTAssertEqual(config.chartData.scNativePoints.map(\.value), [1, 3])
        XCTAssertEqual(config.scNativeSeriesStyle.strokeWidth, 4)
        XCTAssertFalse(config.scNativeSeriesStyle.showArea)
        XCTAssertTrue(config.scNativeSeriesStyle.strokeOnly)
        XCTAssertEqual(config.scNativeSeriesStyle.interpolation, .catmullRom)
    }

    func testLegacyRangeBridgeNormalizesBoundsAndPreservesStrokeOnly() {
        let config = SCRangeChartConfig(
            chartData: [SCRangeChartData(9, 1), SCRangeChartData(3, 5)],
            stroke: true
        )

        XCTAssertEqual(config.chartData.scNativeRangePoints.map(\.lower), [1, 3])
        XCTAssertEqual(config.chartData.scNativeRangePoints.map(\.upper), [9, 5])
        XCTAssertFalse(config.scNativeSeriesStyle.showArea)
        XCTAssertTrue(config.scNativeSeriesStyle.strokeOnly)
        XCTAssertEqual(config.scNativeDomain.actualLowerBound, 1, accuracy: 0.0001)
        XCTAssertEqual(config.scNativeDomain.actualUpperBound, 9, accuracy: 0.0001)
    }

    func testLegacyHistogramBridgeUsesBarCompatiblePointMapping() {
        let config = SCHistogramConfig(
            chartData: [SCHistogramData(1), SCHistogramData(4), SCHistogramData(2)],
            stroke: false,
            color: [.pink]
        )

        XCTAssertEqual(config.chartData.scNativePoints.map(\.value), [1, 4, 2])
        XCTAssertFalse(config.scNativeSeriesStyle.showArea)
        XCTAssertFalse(config.scNativeSeriesStyle.strokeOnly)
        XCTAssertEqual(config.scNativeSeriesStyle.colors, [.pink])
    }
}
