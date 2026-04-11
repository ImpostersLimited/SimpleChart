//
//  SCNativeRuleChart.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Charts
import SwiftUI

/// A chart that renders one or more reference-rule overlays without a primary series.
public struct SCNativeRuleChart: View {
    public let referenceLines: [SCChartReferenceLine]
    public let axesStyle: SCChartAxesStyle
    public let xAxis: SCChartAxis?
    public let yAxis: SCChartAxis?
    public let legend: SCChartLegend
    public let plotStyle: SCChartPlotStyle
    public let domain: SCChartDomain?

    /// Creates a rule chart from prebuilt reference lines.
    public init(
        referenceLines: [SCChartReferenceLine],
        axesStyle: SCChartAxesStyle = .minimal,
        xAxis: SCChartAxis? = nil,
        yAxis: SCChartAxis? = nil,
        legend: SCChartLegend = .hidden,
        plotStyle: SCChartPlotStyle = .standard,
        domain: SCChartDomain? = nil,
        baseZero: Bool = false,
        paddingRatio: Double = 0.03
    ) {
        self.referenceLines = referenceLines
        self.axesStyle = axesStyle
        self.xAxis = xAxis
        self.yAxis = yAxis
        self.legend = legend
        self.plotStyle = plotStyle
        self.domain = domain ?? .auto(values: referenceLines.map(\.value), baseZero: baseZero, paddingRatio: paddingRatio)
    }

    /// Creates a rule chart from raw y-values using a shared title and color.
    public init(
        referenceLine: SCChartReferenceLine,
        axesStyle: SCChartAxesStyle = .minimal,
        xAxis: SCChartAxis? = nil,
        yAxis: SCChartAxis? = nil,
        legend: SCChartLegend = .hidden,
        plotStyle: SCChartPlotStyle = .standard,
        domain: SCChartDomain? = nil,
        baseZero: Bool = false,
        paddingRatio: Double = 0.03
    ) {
        self.init(
            referenceLines: [referenceLine],
            axesStyle: axesStyle,
            xAxis: xAxis,
            yAxis: yAxis,
            legend: legend,
            plotStyle: plotStyle,
            domain: domain,
            baseZero: baseZero,
            paddingRatio: paddingRatio
        )
    }

    public var body: some View {
        SCNativeChartContainer(
            axesStyle: axesStyle,
            xAxis: xAxis,
            yAxis: yAxis,
            legend: legend,
            plotStyle: plotStyle
        ) {
            Chart(referenceLines) { referenceLine in
                RuleMark(y: .value(referenceLine.title, referenceLine.value))
                    .foregroundStyle(referenceLine.color)
                    .lineStyle(referenceLine.strokeStyle)
                    .annotation(
                        position: (referenceLine.annotation ?? .lineLabel(referenceLine.title, color: referenceLine.color)).anchor.chartAnnotationPosition,
                        alignment: (referenceLine.annotation ?? .lineLabel(referenceLine.title, color: referenceLine.color)).alignment
                    ) {
                        SCChartAnnotationLabelView(
                            annotation: referenceLine.annotation ?? .lineLabel(referenceLine.title, color: referenceLine.color)
                        )
                    }
            }
            .scChartDomain(domain)
            .scChartAxes(xAxis: xAxis ?? axesStyle.xAxis, yAxis: yAxis ?? axesStyle.yAxis)
        }
    }
}
