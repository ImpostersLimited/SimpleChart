//
//  SCChartTimePoint.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Foundation

/// A time-series point backed by a `Date` on the x-axis.
public struct SCChartTimePoint: Identifiable, Equatable {
    public let id: String
    public let date: Date
    public let value: Double
    public let label: String?

    /// Creates a time-series point, defaulting the identifier to the date's ISO-8601 representation.
    public init(id: String? = nil, date: Date, value: Double, label: String? = nil) {
        self.id = id ?? date.ISO8601Format()
        self.date = date
        self.value = value
        self.label = label
    }
}

public extension SCChartTimePoint {
    /// Builds time-series points from floating-point `(date, value)` tuples.
    static func make<T: BinaryFloatingPoint>(
        values: [(Date, T)]
    ) -> [SCChartTimePoint] {
        values.map { SCChartTimePoint(date: $0.0, value: Double($0.1)) }
    }

    /// Builds time-series points from integer `(date, value)` tuples.
    static func make<T: BinaryInteger>(
        values: [(Date, T)]
    ) -> [SCChartTimePoint] {
        values.map { SCChartTimePoint(date: $0.0, value: Double($0.1)) }
    }
}
