//
//  SCNativeGroupedBarChart.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Charts
import SwiftUI

public struct SCNativeGroupedBarChart: View {
    public let groups: [SCChartBarGroup]
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?
    public let legend: SCChartLegend
    public let foregroundStyleScale: SCChartForegroundStyleScale

    public init(
        groups: [SCChartBarGroup],
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        legend: SCChartLegend = .visible(position: .bottom),
        foregroundStyleScale: SCChartForegroundStyleScale? = nil,
        palette: [Color] = [.accentColor, .blue, .orange, .green, .pink, .purple]
    ) {
        self.groups = groups
        self.axesStyle = axesStyle
        self.domain = domain ?? .auto(values: groups.flatMap { $0.entries.map(\.value) }, baseZero: true)
        self.legend = legend
        let seriesNames = Array(Set(groups.flatMap { $0.entries.map(\.series) })).sorted()
        self.foregroundStyleScale = foregroundStyleScale ?? .categorical(seriesNames, palette: palette)
    }

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
            Chart(flattenedEntries) { entry in
                BarMark(
                    x: .value("Category", entry.category),
                    y: .value("Value", entry.value)
                )
                .position(by: .value("Series", entry.series))
                .foregroundStyle(by: .value("Series", entry.series))
            }
            .scChartForegroundStyleScale(foregroundStyleScale)
            .scChartDomain(domain)
            .scChartAxes(axesStyle)
        }
    }

    private var flattenedEntries: [FlattenedEntry] {
        groups.flatMap { group in
            group.entries.map {
                FlattenedEntry(category: group.category, series: $0.series, value: $0.value)
            }
        }
    }
}

private struct FlattenedEntry: Identifiable {
    let id: String
    let category: String
    let series: String
    let value: Double

    init(category: String, series: String, value: Double) {
        self.id = "\(category)-\(series)"
        self.category = category
        self.series = series
        self.value = value
    }
}
