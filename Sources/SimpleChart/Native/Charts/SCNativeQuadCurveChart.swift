//
//  SCNativeQuadCurveChart.swift
//
//
//  Created by Codex on 2026-04-09.
//

import SwiftUI

/// A ready-made single-series quadratic-curve chart backed by Swift Charts.
public struct SCNativeQuadCurveChart: View {
    public let points: [SCChartPoint]
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?
    public let referenceLines: [SCChartReferenceLine]

    /// Creates a quadratic-curve chart from prebuilt categorical points.
    public init(
        points: [SCChartPoint],
        seriesStyle: SCChartSeriesStyle = SCChartSeriesStyle(interpolation: .catmullRom),
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

    /// Creates a quadratic-curve chart from floating-point values and optional labels.
    public init<T: BinaryFloatingPoint>(
        values: [T],
        labels: [String]? = nil,
        seriesStyle: SCChartSeriesStyle = SCChartSeriesStyle(interpolation: .catmullRom),
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

    /// Creates a quadratic-curve chart from integer values and optional labels.
    public init<T: BinaryInteger>(
        values: [T],
        labels: [String]? = nil,
        seriesStyle: SCChartSeriesStyle = SCChartSeriesStyle(interpolation: .catmullRom),
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

    /// Creates a quadratic-curve chart from labeled floating-point values.
    public init<T: BinaryFloatingPoint>(
        labeledValues: [(String, T)],
        seriesStyle: SCChartSeriesStyle = SCChartSeriesStyle(interpolation: .catmullRom),
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

    /// Creates a quadratic-curve chart from labeled integer values.
    public init<T: BinaryInteger>(
        labeledValues: [(String, T)],
        seriesStyle: SCChartSeriesStyle = SCChartSeriesStyle(interpolation: .catmullRom),
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
        SCNativeLineChart(
            points: points,
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            domain: domain,
            referenceLines: referenceLines
        )
    }
}
