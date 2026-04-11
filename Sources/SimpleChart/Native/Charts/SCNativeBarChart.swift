//
//  SCNativeBarChart.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Charts
import SwiftUI

/// A ready-made single-series categorical bar chart backed by Swift Charts.
public struct SCNativeBarChart: View {
    public let points: [SCChartPoint]
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?

    /// Creates a bar chart from prebuilt categorical points.
    public init(
        points: [SCChartPoint],
        seriesStyle: SCChartSeriesStyle = SCChartSeriesStyle(),
        axesStyle: SCChartAxesStyle = SCChartAxesStyle(),
        domain: SCChartDomain? = nil
    ) {
        self.points = points
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain
    }

    /// Creates a bar chart from a floating-point array and optional labels.
    public init<T: BinaryFloatingPoint>(
        values: [T],
        labels: [String]? = nil,
        seriesStyle: SCChartSeriesStyle = .bar(),
        axesStyle: SCChartAxesStyle = .minimal,
        domain: SCChartDomain? = nil,
        baseZero: Bool = true,
        paddingRatio: Double = 0.03
    ) {
        let points = SCChartPoint.make(values: values, labels: labels)
        self.init(
            points: points,
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            domain: domain ?? .auto(points: points, baseZero: baseZero, paddingRatio: paddingRatio)
        )
    }

    /// Creates a bar chart from an integer array and optional labels.
    public init<T: BinaryInteger>(
        values: [T],
        labels: [String]? = nil,
        seriesStyle: SCChartSeriesStyle = .bar(),
        axesStyle: SCChartAxesStyle = .minimal,
        domain: SCChartDomain? = nil,
        baseZero: Bool = true,
        paddingRatio: Double = 0.03
    ) {
        let points = SCChartPoint.make(values: values, labels: labels)
        self.init(
            points: points,
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            domain: domain ?? .auto(points: points, baseZero: baseZero, paddingRatio: paddingRatio)
        )
    }

    /// Creates a bar chart from labeled floating-point values.
    public init<T: BinaryFloatingPoint>(
        labeledValues: [(String, T)],
        seriesStyle: SCChartSeriesStyle = .bar(),
        axesStyle: SCChartAxesStyle = .minimal,
        domain: SCChartDomain? = nil,
        baseZero: Bool = true,
        paddingRatio: Double = 0.03
    ) {
        let points = SCChartPoint.make(labeledValues: labeledValues)
        self.init(
            points: points,
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            domain: domain ?? .auto(points: points, baseZero: baseZero, paddingRatio: paddingRatio)
        )
    }

    /// Creates a bar chart from labeled integer values.
    public init<T: BinaryInteger>(
        labeledValues: [(String, T)],
        seriesStyle: SCChartSeriesStyle = .bar(),
        axesStyle: SCChartAxesStyle = .minimal,
        domain: SCChartDomain? = nil,
        baseZero: Bool = true,
        paddingRatio: Double = 0.03
    ) {
        let points = SCChartPoint.make(labeledValues: labeledValues)
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
                BarMark(
                    x: .value("Category", point.plottedXValue),
                    y: .value("Value", point.value)
                )
                .foregroundStyle(seriesStyle.foregroundGradient)
            }
            .scChartDomain(domain)
            .scChartAxes(axesStyle)
        }
    }
}
