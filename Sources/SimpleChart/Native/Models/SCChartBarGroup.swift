//
//  SCChartBarGroup.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Foundation

/// Represents a single series entry inside a grouped bar category.
public struct SCChartBarGroupEntry: Identifiable, Equatable {
    public let id: String
    public let series: String
    public let value: Double

    /// Creates a grouped-bar series entry from a series label and value.
    public init(id: String? = nil, series: String, value: Double) {
        self.id = id ?? series
        self.series = series
        self.value = value
    }
}

/// Represents a single grouped-bar category and its per-series entries.
public struct SCChartBarGroup: Identifiable, Equatable {
    public let id: String
    public let category: String
    public let entries: [SCChartBarGroupEntry]

    /// Creates a grouped-bar category with prebuilt entries.
    public init(id: String? = nil, category: String, entries: [SCChartBarGroupEntry]) {
        self.id = id ?? category
        self.category = category
        self.entries = entries
    }
}

public extension SCChartBarGroup {
    /// Builds a grouped-bar category from floating-point `(series, value)` tuples.
    static func make<T: BinaryFloatingPoint>(
        label: String,
        values: [(String, T)]
    ) -> SCChartBarGroup {
        SCChartBarGroup(
            category: label,
            entries: values.map { SCChartBarGroupEntry(series: $0.0, value: Double($0.1)) }
        )
    }

    /// Builds a grouped-bar category from integer `(series, value)` tuples.
    static func make<T: BinaryInteger>(
        label: String,
        values: [(String, T)]
    ) -> SCChartBarGroup {
        SCChartBarGroup(
            category: label,
            entries: values.map { SCChartBarGroupEntry(series: $0.0, value: Double($0.1)) }
        )
    }

    var maxValue: Double {
        entries.map(\.value).max() ?? 0
    }
}
