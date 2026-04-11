//
//  SCNativeThresholdChart.swift
//
//
//  Created by Codex on 2026-04-09.
//

import SwiftUI

public struct SCNativeThresholdChart: View {
    public let points: [SCChartPoint]
    public let threshold: SCChartReferenceLine
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?

    public init(
        points: [SCChartPoint],
        threshold: SCChartReferenceLine,
        seriesStyle: SCChartSeriesStyle = .line(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil
    ) {
        self.points = points
        self.threshold = threshold
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain ?? .auto(values: points.map(\.value) + [threshold.value], baseZero: true)
    }

    public init<T: BinaryFloatingPoint>(
        values: [T],
        labels: [String]? = nil,
        threshold: SCChartReferenceLine,
        seriesStyle: SCChartSeriesStyle = .line(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        paddingRatio: Double = 0.03
    ) {
        let points = SCChartPoint.make(values: values, labels: labels)
        self.init(
            points: points,
            threshold: threshold,
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            domain: domain ?? .auto(
                values: points.map(\.value) + [threshold.value],
                baseZero: true,
                paddingRatio: paddingRatio
            )
        )
    }

    public var body: some View {
        SCComposedChart(
            marks: [.line(points, style: seriesStyle)],
            overlays: [.referenceLine(threshold)],
            axesStyle: axesStyle,
            domain: domain
        )
    }
}
