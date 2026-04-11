//
//  SCNativeStackedBarChart.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Charts
import SwiftUI

/// A stacked bar chart that accumulates segment values within each category.
public struct SCNativeStackedBarChart: View {
    public let segments: [SCChartStackSegment]
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?
    public let legend: SCChartLegend
    public let foregroundStyleScale: SCChartForegroundStyleScale

    /// Creates a stacked bar chart from prebuilt stack-segment models.
    public init(
        segments: [SCChartStackSegment],
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        legend: SCChartLegend = .visible(position: .bottom),
        foregroundStyleScale: SCChartForegroundStyleScale? = nil,
        palette: [Color] = [.accentColor, .blue, .orange, .green, .pink, .purple]
    ) {
        self.segments = segments
        self.axesStyle = axesStyle
        self.domain = domain ?? .auto(values: SCChartStackSegment.totals(for: segments), baseZero: true)
        self.legend = legend
        let segmentNames = Array(Set(segments.map(\.segment))).sorted()
        self.foregroundStyleScale = foregroundStyleScale ?? .categorical(segmentNames, palette: palette)
    }

    /// Creates a stacked bar chart from explicit segment values and category order.
    public init(
        groups: [SCChartBarGroup],
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        legend: SCChartLegend = .visible(position: .bottom),
        foregroundStyleScale: SCChartForegroundStyleScale? = nil,
        palette: [Color] = [.accentColor, .blue, .orange, .green, .pink, .purple]
    ) {
        self.init(
            segments: SCChartStackSegment.make(groups: groups),
            axesStyle: axesStyle,
            domain: domain,
            legend: legend,
            foregroundStyleScale: foregroundStyleScale,
            palette: palette
        )
    }

    /// Creates a stacked bar chart from floating-point tuples of category, segment, and value.
    public init<T: BinaryFloatingPoint>(
        groups: [(String, [(String, T)])],
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        legend: SCChartLegend = .visible(position: .bottom),
        foregroundStyleScale: SCChartForegroundStyleScale? = nil,
        palette: [Color] = [.accentColor, .blue, .orange, .green, .pink, .purple]
    ) {
        self.init(
            groups: groups.map { SCChartBarGroup.make(label: $0.0, values: $0.1) },
            axesStyle: axesStyle,
            domain: domain,
            legend: legend,
            foregroundStyleScale: foregroundStyleScale,
            palette: palette
        )
    }

    /// Creates a stacked bar chart from integer tuples of category, segment, and value.
    public init<T: BinaryInteger>(
        groups: [(String, [(String, T)])],
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        legend: SCChartLegend = .visible(position: .bottom),
        foregroundStyleScale: SCChartForegroundStyleScale? = nil,
        palette: [Color] = [.accentColor, .blue, .orange, .green, .pink, .purple]
    ) {
        self.init(
            groups: groups.map { SCChartBarGroup.make(label: $0.0, values: $0.1) },
            axesStyle: axesStyle,
            domain: domain,
            legend: legend,
            foregroundStyleScale: foregroundStyleScale,
            palette: palette
        )
    }

    public var body: some View {
        SCNativeChartContainer(axesStyle: axesStyle, legend: legend) {
            Chart(segments) { segment in
                BarMark(
                    x: .value("Category", segment.category),
                    y: .value("Value", segment.value)
                )
                .foregroundStyle(by: .value("Segment", segment.segment))
            }
            .scChartForegroundStyleScale(foregroundStyleScale)
            .scChartDomain(domain)
            .scChartAxes(axesStyle)
        }
    }
}
