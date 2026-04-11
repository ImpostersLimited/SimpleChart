//
//  SCChartReferenceLine.swift
//
//
//  Created by Codex on 2026-04-09.
//

import SwiftUI

/// A reusable horizontal guide line for thresholds, averages, and other reference values.
public struct SCChartReferenceLine: Identifiable, Equatable {
    public let id: String
    public let title: String
    public let value: Double
    public let color: Color
    public let lineWidth: CGFloat
    public let dash: [CGFloat]
    public let annotation: SCChartAnnotation?

    /// Creates a reference line with optional color, stroke styling, and annotation metadata.
    public init(
        id: String,
        title: String,
        value: Double,
        color: Color = .secondary,
        lineWidth: CGFloat = 1,
        dash: [CGFloat] = [4, 4],
        annotation: SCChartAnnotation? = nil
    ) {
        self.id = id
        self.title = title
        self.value = value
        self.color = color
        self.lineWidth = lineWidth
        self.dash = dash
        self.annotation = annotation
    }
}

public extension SCChartReferenceLine {
    /// Creates a threshold line with a default line-label annotation.
    static func threshold(
        _ value: Double,
        label: String,
        color: Color = .red,
        lineWidth: CGFloat = 1,
        dash: [CGFloat] = [4, 4]
    ) -> SCChartReferenceLine {
        SCChartReferenceLine(
            id: "threshold-\(label)-\(value)",
            title: label,
            value: value,
            color: color,
            lineWidth: lineWidth,
            dash: dash,
            annotation: .lineLabel(label, color: color)
        )
    }

    /// Computes an average reference line from a flat point collection.
    static func average(
        of points: [SCChartPoint],
        label: String = "Average",
        color: Color = .secondary,
        lineWidth: CGFloat = 1,
        dash: [CGFloat] = [6, 4]
    ) -> SCChartReferenceLine? {
        guard !points.isEmpty else { return nil }
        let average = points.map(\.value).reduce(0, +) / Double(points.count)
        return SCChartReferenceLine(
            id: "average-\(label)-\(average)",
            title: label,
            value: average,
            color: color,
            lineWidth: lineWidth,
            dash: dash,
            annotation: .lineLabel(label, color: color)
        )
    }

    /// Computes an average reference line from a multi-series line collection.
    static func average(
        of series: [SCChartLineSeries],
        label: String = "Average",
        color: Color = .secondary,
        lineWidth: CGFloat = 1,
        dash: [CGFloat] = [6, 4]
    ) -> SCChartReferenceLine? {
        average(
            of: series.flatMap(\.points),
            label: label,
            color: color,
            lineWidth: lineWidth,
            dash: dash
        )
    }

    /// Computes a minimum reference line from a flat point collection.
    static func minimum(
        of points: [SCChartPoint],
        label: String = "Minimum",
        color: Color = .secondary,
        lineWidth: CGFloat = 1,
        dash: [CGFloat] = [2, 4]
    ) -> SCChartReferenceLine? {
        guard let minimum = points.map(\.value).min() else { return nil }
        return SCChartReferenceLine(
            id: "minimum-\(label)-\(minimum)",
            title: label,
            value: minimum,
            color: color,
            lineWidth: lineWidth,
            dash: dash,
            annotation: .lineLabel(label, color: color)
        )
    }

    /// Computes a minimum reference line from a multi-series line collection.
    static func minimum(
        of series: [SCChartLineSeries],
        label: String = "Minimum",
        color: Color = .secondary,
        lineWidth: CGFloat = 1,
        dash: [CGFloat] = [2, 4]
    ) -> SCChartReferenceLine? {
        minimum(
            of: series.flatMap(\.points),
            label: label,
            color: color,
            lineWidth: lineWidth,
            dash: dash
        )
    }

    /// Computes a maximum reference line from a flat point collection.
    static func maximum(
        of points: [SCChartPoint],
        label: String = "Maximum",
        color: Color = .secondary,
        lineWidth: CGFloat = 1,
        dash: [CGFloat] = [2, 4]
    ) -> SCChartReferenceLine? {
        guard let maximum = points.map(\.value).max() else { return nil }
        return SCChartReferenceLine(
            id: "maximum-\(label)-\(maximum)",
            title: label,
            value: maximum,
            color: color,
            lineWidth: lineWidth,
            dash: dash,
            annotation: .lineLabel(label, color: color)
        )
    }

    /// Computes a maximum reference line from a multi-series line collection.
    static func maximum(
        of series: [SCChartLineSeries],
        label: String = "Maximum",
        color: Color = .secondary,
        lineWidth: CGFloat = 1,
        dash: [CGFloat] = [2, 4]
    ) -> SCChartReferenceLine? {
        maximum(
            of: series.flatMap(\.points),
            label: label,
            color: color,
            lineWidth: lineWidth,
            dash: dash
        )
    }
}
