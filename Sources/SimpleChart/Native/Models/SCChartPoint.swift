//
//  SCChartPoint.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Foundation

/// A single categorical chart point used by the native wrapper layer.
public struct SCChartPoint: Identifiable, Equatable, Codable {
    public let id: String
    public let xLabel: String?
    public let value: Double

    /// Creates a chart point with a stable identifier, optional category label, and plotted value.
    public init(id: String, xLabel: String? = nil, value: Double) {
        self.id = id
        self.xLabel = xLabel
        self.value = value
    }
}

public extension SCChartPoint {
    /// Builds categorical points from a numeric array and optional parallel labels.
    static func make<T: BinaryFloatingPoint>(
        values: [T],
        labels: [String]? = nil
    ) -> [SCChartPoint] {
        values.enumerated().map { index, value in
            SCChartPoint(
                id: "\(index)",
                xLabel: labels?[safe: index],
                value: Double(value)
            )
        }
    }

    /// Builds categorical points from an integer array and optional parallel labels.
    static func make<T: BinaryInteger>(
        values: [T],
        labels: [String]? = nil
    ) -> [SCChartPoint] {
        values.enumerated().map { index, value in
            SCChartPoint(
                id: "\(index)",
                xLabel: labels?[safe: index],
                value: Double(value)
            )
        }
    }

    /// Builds categorical points from `(label, value)` pairs.
    static func make<T: BinaryFloatingPoint>(
        labeledValues: [(String, T)]
    ) -> [SCChartPoint] {
        labeledValues.enumerated().map { index, element in
            SCChartPoint(
                id: "\(index)",
                xLabel: element.0,
                value: Double(element.1)
            )
        }
    }

    /// Builds categorical points from integer `(label, value)` pairs.
    static func make<T: BinaryInteger>(
        labeledValues: [(String, T)]
    ) -> [SCChartPoint] {
        labeledValues.enumerated().map { index, element in
            SCChartPoint(
                id: "\(index)",
                xLabel: element.0,
                value: Double(element.1)
            )
        }
    }
}
