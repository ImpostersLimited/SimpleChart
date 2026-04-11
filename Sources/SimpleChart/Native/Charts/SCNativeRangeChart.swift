//
//  SCNativeRangeChart.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Charts
import SwiftUI

public struct SCNativeRangeChart: View {
    public let points: [SCChartRangePoint]
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?

    public init(
        points: [SCChartRangePoint],
        seriesStyle: SCChartSeriesStyle = SCChartSeriesStyle(),
        axesStyle: SCChartAxesStyle = SCChartAxesStyle(),
        domain: SCChartDomain? = nil
    ) {
        self.points = points
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain
    }

    public init<T: BinaryFloatingPoint>(
        ranges: [(T, T)],
        labels: [String]? = nil,
        seriesStyle: SCChartSeriesStyle = .rangeFill(),
        axesStyle: SCChartAxesStyle = .minimal,
        domain: SCChartDomain? = nil,
        baseZero: Bool = false,
        paddingRatio: Double = 0.03
    ) {
        let points = SCChartRangePoint.make(ranges: ranges, labels: labels)
        self.init(
            points: points,
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            domain: domain ?? .auto(points: points, baseZero: baseZero, paddingRatio: paddingRatio)
        )
    }

    public init<T: BinaryInteger>(
        ranges: [(T, T)],
        labels: [String]? = nil,
        seriesStyle: SCChartSeriesStyle = .rangeFill(),
        axesStyle: SCChartAxesStyle = .minimal,
        domain: SCChartDomain? = nil,
        baseZero: Bool = false,
        paddingRatio: Double = 0.03
    ) {
        let points = SCChartRangePoint.make(ranges: ranges, labels: labels)
        self.init(
            points: points,
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            domain: domain ?? .auto(points: points, baseZero: baseZero, paddingRatio: paddingRatio)
        )
    }

    public init<T: BinaryFloatingPoint>(
        labeledRanges: [(String, T, T)],
        seriesStyle: SCChartSeriesStyle = .rangeFill(),
        axesStyle: SCChartAxesStyle = .minimal,
        domain: SCChartDomain? = nil,
        baseZero: Bool = false,
        paddingRatio: Double = 0.03
    ) {
        let points = SCChartRangePoint.make(labeledRanges: labeledRanges)
        self.init(
            points: points,
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            domain: domain ?? .auto(points: points, baseZero: baseZero, paddingRatio: paddingRatio)
        )
    }

    public init<T: BinaryInteger>(
        labeledRanges: [(String, T, T)],
        seriesStyle: SCChartSeriesStyle = .rangeFill(),
        axesStyle: SCChartAxesStyle = .minimal,
        domain: SCChartDomain? = nil,
        baseZero: Bool = false,
        paddingRatio: Double = 0.03
    ) {
        let points = SCChartRangePoint.make(labeledRanges: labeledRanges)
        self.init(
            points: points,
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            domain: domain ?? .auto(points: points, baseZero: baseZero, paddingRatio: paddingRatio)
        )
    }

    public var body: some View {
        SCNativeChartContainer(axesStyle: axesStyle) {
            Chart(points) { point in
                if seriesStyle.strokeOnly {
                    RuleMark(
                        x: .value("Category", point.plottedXValue),
                        yStart: .value("Lower", point.lower),
                        yEnd: .value("Upper", point.upper)
                    )
                    .foregroundStyle(seriesStyle.foregroundGradient)
                    .lineStyle(StrokeStyle(lineWidth: max(seriesStyle.strokeWidth, 8), lineCap: .round))
                } else {
                    BarMark(
                        x: .value("Category", point.plottedXValue),
                        yStart: .value("Lower", point.lower),
                        yEnd: .value("Upper", point.upper),
                        width: .ratio(0.55)
                    )
                    .foregroundStyle(seriesStyle.foregroundGradient)
                }
            }
            .scChartDomain(domain)
            .scChartAxes(axesStyle)
        }
    }
}
