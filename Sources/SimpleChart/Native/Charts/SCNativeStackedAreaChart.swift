//
//  SCNativeStackedAreaChart.swift
//
//
//  Created by Codex on 2026-04-10.
//

import Charts
import Foundation
import SwiftUI

public struct SCNativeStackedAreaChart: View {
    public let series: [SCChartLineSeries]
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?
    public let legend: SCChartLegend
    public let foregroundStyleScale: SCChartForegroundStyleScale
    public let referenceLines: [SCChartReferenceLine]

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
        let bands = Self.makeBands(series: series)
        self.domain = domain ?? .auto(values: bands.flatMap { [$0.lowerValue, $0.upperValue] }, baseZero: true)
        self.legend = legend
        let domainTokens = series.map(\.name)
        let palette = series.map(\.style.primaryColor)
        self.foregroundStyleScale = foregroundStyleScale ?? .categorical(domainTokens, palette: palette)
        self.referenceLines = referenceLines
    }

    public var body: some View {
        SCNativeChartContainer(axesStyle: axesStyle, legend: legend) {
            Chart {
                ForEach(stackedBands) { band in
                    AreaMark(
                        x: .value("Category", band.category),
                        yStart: .value("Lower", band.lowerValue),
                        yEnd: .value("Upper", band.upperValue)
                    )
                    .foregroundStyle(by: .value("Series", band.series))
                    .interpolationMethod(band.style.chartInterpolationMethod)

                    LineMark(
                        x: .value("Category", band.category),
                        y: .value("Value", band.upperValue)
                    )
                    .foregroundStyle(by: .value("Series", band.series))
                    .lineStyle(StrokeStyle(lineWidth: band.style.strokeWidth))
                    .interpolationMethod(band.style.chartInterpolationMethod)
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

    private var stackedBands: [SCChartStackedAreaBand] {
        Self.makeBands(series: series)
    }
}

private struct SCChartStackedAreaBand: Identifiable {
    let id: String
    let category: String
    let series: String
    let lowerValue: Double
    let upperValue: Double
    let style: SCChartSeriesStyle
}

private extension SCNativeStackedAreaChart {
    static func makeBands(series: [SCChartLineSeries]) -> [SCChartStackedAreaBand] {
        let categories = orderedCategories(series: series)
        var runningTotals = Dictionary(uniqueKeysWithValues: categories.map { ($0, 0.0) })
        var bands: [SCChartStackedAreaBand] = []

        for lineSeries in series {
            let pointsByCategory = Dictionary(uniqueKeysWithValues: lineSeries.points.map { ($0.plottedXValue, $0.value) })
            for category in categories {
                let value = pointsByCategory[category] ?? 0
                let lower = runningTotals[category] ?? 0
                let upper = lower + value
                bands.append(
                    SCChartStackedAreaBand(
                        id: "\(lineSeries.id)-\(category)",
                        category: category,
                        series: lineSeries.name,
                        lowerValue: lower,
                        upperValue: upper,
                        style: lineSeries.style
                    )
                )
                runningTotals[category] = upper
            }
        }

        return bands
    }

    static func orderedCategories(series: [SCChartLineSeries]) -> [String] {
        let labels = series.flatMap { $0.points.map(\.plottedXValue) }
        return Array(NSOrderedSet(array: labels)) as? [String] ?? labels
    }
}
