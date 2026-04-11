//
//  SCChartLineSeries.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Foundation

/// Represents one named series inside a multi-line chart.
public struct SCChartLineSeries: Identifiable, Equatable {
    public let id: String
    public let name: String
    public let points: [SCChartPoint]
    public let style: SCChartSeriesStyle

    /// Creates a named line series from prebuilt points and optional styling.
    public init(
        id: String? = nil,
        name: String,
        points: [SCChartPoint],
        style: SCChartSeriesStyle = .line()
    ) {
        self.id = id ?? name
        self.name = name
        self.points = points
        self.style = style
    }
}

public extension SCChartLineSeries {
    /// Builds a line series from floating-point values and optional labels.
    static func make<T: BinaryFloatingPoint>(
        name: String,
        values: [T],
        labels: [String]? = nil,
        style: SCChartSeriesStyle = .line()
    ) -> SCChartLineSeries {
        SCChartLineSeries(
            name: name,
            points: SCChartPoint.make(values: values, labels: labels),
            style: style
        )
    }

    /// Builds a line series from integer values and optional labels.
    static func make<T: BinaryInteger>(
        name: String,
        values: [T],
        labels: [String]? = nil,
        style: SCChartSeriesStyle = .line()
    ) -> SCChartLineSeries {
        SCChartLineSeries(
            name: name,
            points: SCChartPoint.make(values: values, labels: labels),
            style: style
        )
    }
}
