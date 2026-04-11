import XCTest
import SwiftUI
@testable import SimpleChart

final class SCNativeMultiLineChartTests: XCTestCase {
    func testNativeMultiLineChartStoresSeriesAndAutoDomain() {
        let revenue = SCChartLineSeries.make(
            name: "Revenue",
            values: [12, 18, 15],
            labels: ["Jan", "Feb", "Mar"],
            style: .line([.blue], strokeWidth: 3)
        )
        let cost = SCChartLineSeries.make(
            name: "Cost",
            values: [8, 10, 9],
            labels: ["Jan", "Feb", "Mar"],
            style: .line([.orange], strokeWidth: 2)
        )
        let average = SCChartReferenceLine.average(of: [revenue, cost])

        let chart = SCNativeMultiLineChart(
            series: [revenue, cost],
            axesStyle: .standard(x: "Month", y: "Amount"),
            referenceLines: average.map { [$0] } ?? []
        )

        XCTAssertEqual(chart.series.map(\.name), ["Revenue", "Cost"])
        XCTAssertEqual(chart.domain?.actualUpperBound, 18)
        XCTAssertEqual(chart.axesStyle.xLegend, "Month")
        XCTAssertEqual(chart.axesStyle.yLegend, "Amount")
        XCTAssertEqual(chart.referenceLines.first?.title, "Average")
    }
}
