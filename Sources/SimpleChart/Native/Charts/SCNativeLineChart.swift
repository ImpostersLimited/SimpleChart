//
//  SCNativeLineChart.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Charts
import SwiftUI

/// A ready-made single-series categorical line chart backed by Swift Charts.
public struct SCNativeLineChart: View {
    public let points: [SCChartPoint]
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?
    public let referenceLines: [SCChartReferenceLine]

    /// Creates a line chart from prebuilt categorical points.
    public init(
        points: [SCChartPoint],
        seriesStyle: SCChartSeriesStyle = SCChartSeriesStyle(),
        axesStyle: SCChartAxesStyle = SCChartAxesStyle(),
        domain: SCChartDomain? = nil,
        referenceLines: [SCChartReferenceLine] = []
    ) {
        self.points = points
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain
        self.referenceLines = referenceLines
    }

    /// Creates a line chart from a floating-point array and optional labels.
    public init<T: BinaryFloatingPoint>(
        values: [T],
        labels: [String]? = nil,
        seriesStyle: SCChartSeriesStyle = .line(),
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

    /// Creates a line chart from an integer array and optional labels.
    public init<T: BinaryInteger>(
        values: [T],
        labels: [String]? = nil,
        seriesStyle: SCChartSeriesStyle = .line(),
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

    /// Creates a line chart from labeled floating-point values.
    public init<T: BinaryFloatingPoint>(
        labeledValues: [(String, T)],
        seriesStyle: SCChartSeriesStyle = .line(),
        axesStyle: SCChartAxesStyle = .minimal,
        domain: SCChartDomain? = nil,
        baseZero: Bool = false,
        paddingRatio: Double = 0.03,
        referenceLines: [SCChartReferenceLine] = []
    ) {
        let points = SCChartPoint.make(labeledValues: labeledValues)
        self.init(
            points: points,
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            domain: domain ?? .auto(points: points, baseZero: baseZero, paddingRatio: paddingRatio),
            referenceLines: referenceLines
        )
    }

    /// Creates a line chart from labeled integer values.
    public init<T: BinaryInteger>(
        labeledValues: [(String, T)],
        seriesStyle: SCChartSeriesStyle = .line(),
        axesStyle: SCChartAxesStyle = .minimal,
        domain: SCChartDomain? = nil,
        baseZero: Bool = false,
        paddingRatio: Double = 0.03,
        referenceLines: [SCChartReferenceLine] = []
    ) {
        let points = SCChartPoint.make(labeledValues: labeledValues)
        self.init(
            points: points,
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            domain: domain ?? .auto(points: points, baseZero: baseZero, paddingRatio: paddingRatio),
            referenceLines: referenceLines
        )
    }

    public var body: some View {
        SCNativeChartContainer(axesStyle: axesStyle) {
            Chart(points) { point in
                if seriesStyle.showArea {
                    AreaMark(
                        x: .value("Category", point.plottedXValue),
                        y: .value("Value", point.value)
                    )
                    .foregroundStyle(seriesStyle.foregroundGradient)
                    .interpolationMethod(seriesStyle.chartInterpolationMethod)
                }

                LineMark(
                    x: .value("Category", point.plottedXValue),
                    y: .value("Value", point.value)
                )
                .foregroundStyle(seriesStyle.foregroundGradient)
                .lineStyle(StrokeStyle(lineWidth: seriesStyle.strokeWidth))
                .interpolationMethod(seriesStyle.chartInterpolationMethod)

                ForEach(referenceLines) { referenceLine in
                    RuleMark(y: .value(referenceLine.title, referenceLine.value))
                        .foregroundStyle(referenceLine.color)
                        .lineStyle(referenceLine.strokeStyle)
                        .annotation(position: .top, alignment: .leading) {
                            Text(referenceLine.title)
                                .font(.caption2)
                                .foregroundStyle(referenceLine.color)
                        }
                }
            }
            .scChartDomain(domain)
            .scChartAxes(axesStyle)
        }
    }
}
