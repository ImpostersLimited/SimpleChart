import XCTest
import SwiftUI
@testable import SimpleChart

final class SCNativeHistogramChartTests: XCTestCase {
    func testNativeHistogramChartBinsRawValues() {
        let values: [Double] = [2, 4, 9, 11, 13, 17]

        let chart = SCNativeHistogramChart(values: values, binCount: 3)

        XCTAssertEqual(chart.bins.count, 3)
        XCTAssertEqual(chart.bins.reduce(0) { $0 + $1.count }, values.count)
    }

    func testNativeHistogramChartAcceptsPreBinnedInput() {
        let bins = [
            SCHistogramBin(id: "0", lowerBound: 0, upperBound: 10, count: 2),
            SCHistogramBin(id: "1", lowerBound: 10, upperBound: 20, count: 4)
        ]
        let style = SCChartSeriesStyle(colors: [.orange], strokeWidth: 2)

        let chart = SCNativeHistogramChart(bins: bins, seriesStyle: style)

        XCTAssertEqual(chart.bins, bins)
        XCTAssertEqual(chart.seriesStyle.colors.count, 1)
        XCTAssertEqual(chart.seriesStyle.strokeWidth, 2)
    }

    func testNativeHistogramChartConvenienceInitializerBuildsCountDomain() {
        let chart = SCNativeHistogramChart(values: [1, 2, 2, 4, 5, 5, 5], binCount: 3)

        XCTAssertEqual(chart.bins.count, 3)
        XCTAssertEqual(chart.domain?.lowerBound, 0)
        XCTAssertEqual(chart.domain?.actualUpperBound, 4)
    }
}
