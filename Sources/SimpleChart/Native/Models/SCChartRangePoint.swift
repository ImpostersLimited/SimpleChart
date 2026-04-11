//
//  SCChartRangePoint.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Foundation

/// A categorical range point with normalized lower and upper bounds.
public struct SCChartRangePoint: Identifiable, Equatable, Codable {
    public let id: String
    public let xLabel: String?
    public let lower: Double
    public let upper: Double

    /// Creates a range point and normalizes the incoming bounds so `lower <= upper`.
    public init(id: String, xLabel: String? = nil, lower: Double, upper: Double) {
        self.id = id
        self.xLabel = xLabel
        self.lower = min(lower, upper)
        self.upper = max(lower, upper)
    }
}

public extension SCChartRangePoint {
    /// Builds range points from unlabeled lower/upper tuples and optional parallel labels.
    static func make<T: BinaryFloatingPoint>(
        ranges: [(T, T)],
        labels: [String]? = nil
    ) -> [SCChartRangePoint] {
        ranges.enumerated().map { index, range in
            let label = labels.map { $0.indices.contains(index) ? $0[index] : nil } ?? nil
            return SCChartRangePoint(
                id: "\(index)",
                xLabel: label,
                lower: Double(range.0),
                upper: Double(range.1)
            )
        }
    }

    /// Builds range points from integer lower/upper tuples and optional parallel labels.
    static func make<T: BinaryInteger>(
        ranges: [(T, T)],
        labels: [String]? = nil
    ) -> [SCChartRangePoint] {
        ranges.enumerated().map { index, range in
            let label = labels.map { $0.indices.contains(index) ? $0[index] : nil } ?? nil
            return SCChartRangePoint(
                id: "\(index)",
                xLabel: label,
                lower: Double(range.0),
                upper: Double(range.1)
            )
        }
    }

    /// Builds range points from labeled floating-point tuples.
    static func make<T: BinaryFloatingPoint>(
        labeledRanges: [(String, T, T)]
    ) -> [SCChartRangePoint] {
        labeledRanges.enumerated().map { index, range in
            SCChartRangePoint(
                id: "\(index)",
                xLabel: range.0,
                lower: Double(range.1),
                upper: Double(range.2)
            )
        }
    }

    /// Builds range points from labeled integer tuples.
    static func make<T: BinaryInteger>(
        labeledRanges: [(String, T, T)]
    ) -> [SCChartRangePoint] {
        labeledRanges.enumerated().map { index, range in
            SCChartRangePoint(
                id: "\(index)",
                xLabel: range.0,
                lower: Double(range.1),
                upper: Double(range.2)
            )
        }
    }
}
