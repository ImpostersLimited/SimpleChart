//
//  SCNativeChartContainer.swift
//
//
//  Created by Codex on 2026-04-09.
//

import SwiftUI

/// Wraps a `Chart` with shared axis-title, legend, and plot-area presentation used by native wrappers.
public struct SCNativeChartContainer<Content: View>: View {
    private let xAxis: SCChartAxis
    private let yAxis: SCChartAxis
    private let legend: SCChartLegend
    private let plotStyle: SCChartPlotStyle
    private let content: Content

    /// Creates a chart container that derives axis titles from a shared axes style unless overridden.
    public init(
        axesStyle: SCChartAxesStyle,
        xAxis: SCChartAxis? = nil,
        yAxis: SCChartAxis? = nil,
        legend: SCChartLegend = .hidden,
        plotStyle: SCChartPlotStyle = .standard,
        @ViewBuilder content: () -> Content
    ) {
        self.xAxis = xAxis ?? axesStyle.xAxis
        self.yAxis = yAxis ?? axesStyle.yAxis
        self.legend = legend
        self.plotStyle = plotStyle
        self.content = content()
    }

    public var body: some View {
        HStack(spacing: 8) {
            if !yAxis.title.isEmpty {
                Text(yAxis.title)
                    .font(yAxis.titleFont)
                    .foregroundStyle(yAxis.titleColor)
                    .rotationEffect(.degrees(-90))
                    .fixedSize()
            }

            VStack(spacing: 8) {
                content
                    .scChartLegend(legend)
                    .scChartPlotStyle(plotStyle)

                if !xAxis.title.isEmpty {
                    Text(xAxis.title)
                        .font(xAxis.titleFont)
                        .foregroundStyle(xAxis.titleColor)
                }
            }
        }
    }
}
