//
//  SCNativeAreaChart.swift
//
//
//  Created by Codex on 2026-04-09.
//

import SwiftUI

public struct SCNativeAreaChart: View {
    public let points: [SCChartPoint]
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?
    public let referenceLines: [SCChartReferenceLine]

    public init(
        points: [SCChartPoint],
        seriesStyle: SCChartSeriesStyle = .area(),
        axesStyle: SCChartAxesStyle = .minimal,
        domain: SCChartDomain? = nil,
        referenceLines: [SCChartReferenceLine] = []
    ) {
        self.points = points
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain
        self.referenceLines = referenceLines
    }

    public init<T: BinaryFloatingPoint>(
        values: [T],
        labels: [String]? = nil,
        seriesStyle: SCChartSeriesStyle = .area(),
        axesStyle: SCChartAxesStyle = .minimal,
        domain: SCChartDomain? = nil,
        baseZero: Bool = false,
        paddingRatio: Double = 0.03,
        referenceLines: [SCChartReferenceLine] = []
    ) {
        let points = SCChartPoint.make(values: values, labels: labels)
        self.init(
            points: points,
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            domain: domain ?? .auto(points: points, baseZero: baseZero, paddingRatio: paddingRatio),
            referenceLines: referenceLines
        )
    }

    public var body: some View {
        SCComposedChart(
            marks: [.area(points, style: seriesStyle)] + referenceLines.map(SCChartMark.rule),
            axesStyle: axesStyle,
            domain: domain
        )
    }
}
