//
//  SCChartBarGroup.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Foundation

public struct SCChartBarGroupEntry: Identifiable, Equatable {
    public let id: String
    public let series: String
    public let value: Double

    public init(id: String? = nil, series: String, value: Double) {
        self.id = id ?? series
        self.series = series
        self.value = value
    }
}

public struct SCChartBarGroup: Identifiable, Equatable {
    public let id: String
    public let category: String
    public let entries: [SCChartBarGroupEntry]

    public init(id: String? = nil, category: String, entries: [SCChartBarGroupEntry]) {
        self.id = id ?? category
        self.category = category
        self.entries = entries
    }
}

public extension SCChartBarGroup {
    static func make<T: BinaryFloatingPoint>(
        label: String,
        values: [(String, T)]
    ) -> SCChartBarGroup {
        SCChartBarGroup(
            category: label,
            entries: values.map { SCChartBarGroupEntry(series: $0.0, value: Double($0.1)) }
        )
    }

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
