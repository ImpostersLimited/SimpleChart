//
//  SCNativeGroupedAreaChart.swift
//
//
//  Created by Codex on 2026-04-10.
//

import Charts
import SwiftUI

/// A multi-series grouped area chart built from named line-series models.
public struct SCNativeGroupedAreaChart: View {
    public let series: [SCChartLineSeries]
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?
    public let legend: SCChartLegend
    public let foregroundStyleScale: SCChartForegroundStyleScale
    public let referenceLines: [SCChartReferenceLine]

    /// Creates a grouped area chart from prebuilt line-series values.
    public init(
        series: [SCChartLineSeries],
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        legend: SCChartLegend = .visible(position: .bottom),
        foregroundStyleScale: SCChartForegroundStyleScale? = nil,
        referenceLines: [SCChartReferenceLine] = []
    ) {
        self.series = series
        self.axesStyle = axesStyle
        self.domain = domain ?? .auto(values: series.flatMap { $0.points.map(\.value) })
        self.legend = legend
        let domainTokens = series.map(\.name)
        let palette = series.map(\.style.primaryColor)
        self.foregroundStyleScale = foregroundStyleScale ?? .categorical(domainTokens, palette: palette)
        self.referenceLines = referenceLines
    }

    public var body: some View {
        SCNativeChartContainer(axesStyle: axesStyle, legend: legend) {
            Chart {
                ForEach(series) { lineSeries in
                    ForEach(lineSeries.points) { point in
                        AreaMark(
                            x: .value("Category", point.plottedXValue),
                            y: .value("Value", point.value)
                        )
                        .foregroundStyle(by: .value("Series", lineSeries.name))
                        .interpolationMethod(lineSeries.style.chartInterpolationMethod)

                        LineMark(
                            x: .value("Category", point.plottedXValue),
                            y: .value("Value", point.value)
                        )
                        .foregroundStyle(by: .value("Series", lineSeries.name))
                        .lineStyle(StrokeStyle(lineWidth: lineSeries.style.strokeWidth))
                        .interpolationMethod(lineSeries.style.chartInterpolationMethod)
                    }
                }

                ForEach(referenceLines) { referenceLine in
                    RuleMark(y: .value(referenceLine.title, referenceLine.value))
                        .foregroundStyle(referenceLine.color)
                        .lineStyle(referenceLine.strokeStyle)
                }
            }
            .scChartForegroundStyleScale(foregroundStyleScale)
            .scChartDomain(domain)
            .scChartAxes(axesStyle)
        }
    }
}
