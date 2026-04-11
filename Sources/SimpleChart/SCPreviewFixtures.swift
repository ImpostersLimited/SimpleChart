//
//  SCPreviewFixtures.swift
//
//
//  Created by Codex on 2026-04-09.
//

import SwiftUI

enum SCPreviewFixtures {
    static let barValues: [Double] = [0.0, 1.0, 2.0, 1.0, 4.0, 3.0, 2.0, 3.0, 5.0, 3.5]
    static let lineValues: [Double] = [0.0, 9.0, 1.0, 1.0, 4.0, 7.0, 2.0, 3.0, 10.0, 0.0]
    static let quadValues: [Double] = [1.0, 4.0, 1.0, 5.0, 2.0, 1.0, 1.0, 1.0, 1.0, 5.0]
    static let rangePairs: [(Double, Double)] = [(0.0, 10.0), (1.0, 7.0), (2.0, 9.0), (1.0, 4.0), (4.0, 9.0), (3.0, 6.0), (2.0, 7.0), (3.0, 8.0), (5.0, 9.0), (0.0, 9.0)]

    static let nativeBarPoints = barValues.enumerated().map {
        SCChartPoint(id: "bar-\($0.offset)", xLabel: "\($0.offset)", value: $0.element)
    }
    static let nativeLinePoints = lineValues.enumerated().map {
        SCChartPoint(id: "line-\($0.offset)", xLabel: "\($0.offset)", value: $0.element)
    }
    static let nativeQuadPoints = quadValues.enumerated().map {
        SCChartPoint(id: "quad-\($0.offset)", xLabel: "\($0.offset)", value: $0.element)
    }
    static let nativeRangePoints = rangePairs.enumerated().map {
        SCChartRangePoint(id: "range-\($0.offset)", xLabel: "\($0.offset)", lower: $0.element.0, upper: $0.element.1)
    }
    static let nativeAxesStyle = SCChartAxesStyle(
        showXAxis: true,
        showYAxis: true,
        showGrid: true,
        showYAxisLabels: true
    )
}
