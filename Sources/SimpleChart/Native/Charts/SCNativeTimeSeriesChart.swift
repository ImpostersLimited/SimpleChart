//
//  SCNativeTimeSeriesChart.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Charts
import SwiftUI

/// A ready-made time-series line chart with date-aware axis formatting.
public struct SCNativeTimeSeriesChart: View {
    public let points: [SCChartTimePoint]
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?
    public let referenceLines: [SCChartReferenceLine]
    public let xAxisFormat: SCChartDateValueFormat
    public let yAxisFormat: SCChartNumericValueFormat

    /// Creates a time-series chart from prebuilt time points.
    public init(
        points: [SCChartTimePoint],
        seriesStyle: SCChartSeriesStyle = .line(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        referenceLines: [SCChartReferenceLine] = [],
        xAxisFormat: SCChartDateValueFormat = .monthDay,
        yAxisFormat: SCChartNumericValueFormat = .automatic
    ) {
        self.points = points.sorted { $0.date < $1.date }
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain ?? .auto(values: points.map(\.value), baseZero: false)
        self.referenceLines = referenceLines
        self.xAxisFormat = xAxisFormat
        self.yAxisFormat = yAxisFormat
    }

    /// Creates a time-series chart from floating-point `(date, value)` tuples.
    public init<T: BinaryFloatingPoint>(
        values: [(Date, T)],
        seriesStyle: SCChartSeriesStyle = .line(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        referenceLines: [SCChartReferenceLine] = [],
        xAxisFormat: SCChartDateValueFormat = .monthDay,
        yAxisFormat: SCChartNumericValueFormat = .automatic
    ) {
        self.init(
            points: SCChartTimePoint.make(values: values),
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            domain: domain,
            referenceLines: referenceLines,
            xAxisFormat: xAxisFormat,
            yAxisFormat: yAxisFormat
        )
    }

    /// Creates a time-series chart from integer `(date, value)` tuples.
    public init<T: BinaryInteger>(
        values: [(Date, T)],
        seriesStyle: SCChartSeriesStyle = .line(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        referenceLines: [SCChartReferenceLine] = [],
        xAxisFormat: SCChartDateValueFormat = .monthDay,
        yAxisFormat: SCChartNumericValueFormat = .automatic
    ) {
        self.init(
            points: SCChartTimePoint.make(values: values),
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            domain: domain,
            referenceLines: referenceLines,
            xAxisFormat: xAxisFormat,
            yAxisFormat: yAxisFormat
        )
    }

    public var body: some View {
        SCNativeChartContainer(axesStyle: axesStyle) {
            Chart(points) { point in
                if seriesStyle.showArea {
                    AreaMark(
                        x: .value("Date", point.date),
                        y: .value("Value", point.value)
                    )
                    .foregroundStyle(seriesStyle.foregroundGradient)
                    .interpolationMethod(seriesStyle.chartInterpolationMethod)
                }

                LineMark(
                    x: .value("Date", point.date),
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
            .scChartDateXAxis(axesStyle, format: xAxisFormat)
            .scChartNumericYAxis(axesStyle, format: yAxisFormat)
        }
    }
}
