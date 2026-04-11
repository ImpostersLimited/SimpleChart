import XCTest
import SwiftUI
@testable import SimpleChart

final class SCNativeCurveChartTests: XCTestCase {
    func testNativeQuadCurveChartDefaultsToCatmullRomInterpolation() {
        let points = [
            SCChartPoint(id: "0", xLabel: "A", value: 1)
        ]

        let chart = SCNativeQuadCurveChart(points: points)

        XCTAssertEqual(chart.points, points)
        XCTAssertEqual(chart.seriesStyle.interpolation, .catmullRom)
    }
}
