//
//  SCNativeMultiLineChart.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Charts
import SwiftUI

public struct SCNativeMultiLineChart: View {
    public let series: [SCChartLineSeries]
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?
    public let referenceLines: [SCChartReferenceLine]

    public init(
        series: [SCChartLineSeries],
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        referenceLines: [SCChartReferenceLine] = []
    ) {
        self.series = series
        self.axesStyle = axesStyle
        self.domain = domain ?? .auto(values: series.flatMap { $0.points.map(\.value) })
        self.referenceLines = referenceLines
    }

    public var body: some View {
        SCNativeChartContainer(axesStyle: axesStyle) {
            Chart {
                ForEach(series) { lineSeries in
                    ForEach(lineSeries.points) { point in
                        if lineSeries.style.showArea {
                            AreaMark(
                                x: .value("Category", point.plottedXValue),
                                y: .value("Value", point.value)
                            )
                            .foregroundStyle(lineSeries.style.foregroundGradient)
                            .interpolationMethod(lineSeries.style.chartInterpolationMethod)
                        }

                        LineMark(
                            x: .value("Category", point.plottedXValue),
                            y: .value("Value", point.value)
                        )
                        .foregroundStyle(lineSeries.style.foregroundGradient)
                        .lineStyle(StrokeStyle(lineWidth: lineSeries.style.strokeWidth))
                        .interpolationMethod(lineSeries.style.chartInterpolationMethod)
                    }
                }

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
