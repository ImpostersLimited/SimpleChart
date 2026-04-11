//
//  SCChartStackSegment.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Foundation

public struct SCChartStackSegment: Identifiable, Equatable {
    public let id: String
    public let category: String
    public let segment: String
    public let value: Double

    public init(id: String? = nil, category: String, segment: String, value: Double) {
        self.id = id ?? "\(category)-\(segment)"
        self.category = category
        self.segment = segment
        self.value = value
    }
}

public extension SCChartStackSegment {
    static func make<T: BinaryFloatingPoint>(
        category: String,
        values: [(String, T)]
    ) -> [SCChartStackSegment] {
        values.map { SCChartStackSegment(category: category, segment: $0.0, value: Double($0.1)) }
    }

    static func make<T: BinaryInteger>(
        category: String,
        values: [(String, T)]
    ) -> [SCChartStackSegment] {
        values.map { SCChartStackSegment(category: category, segment: $0.0, value: Double($0.1)) }
    }

    static func make(groups: [SCChartBarGroup]) -> [SCChartStackSegment] {
        groups.flatMap { group in
            group.entries.map {
                SCChartStackSegment(category: group.category, segment: $0.series, value: $0.value)
            }
        }
    }

    static func totals(for segments: [SCChartStackSegment]) -> [Double] {
        Dictionary(grouping: segments, by: \.category)
            .values
            .map { $0.reduce(0) { $0 + $1.value } }
    }
}
