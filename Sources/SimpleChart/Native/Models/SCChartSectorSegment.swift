//
//  SCChartSectorSegment.swift
//
//
//  Created by Codex on 2026-04-09.
//

import SwiftUI

/// Represents one segment in a sector or donut chart.
public struct SCChartSectorSegment: Identifiable, Equatable {
    public let id: String
    public let title: String
    public let value: Double
    public let color: Color?

    /// Creates a sector segment from title, value, and optional explicit color.
    public init(id: String? = nil, title: String, value: Double, color: Color? = nil) {
        self.id = id ?? title
        self.title = title
        self.value = value
        self.color = color
    }
}

public extension SCChartSectorSegment {
    static func make(_ title: String, _ value: Double, color: Color? = nil) -> SCChartSectorSegment {
        SCChartSectorSegment(title: title, value: value, color: color)
    }

    static func make<T: BinaryFloatingPoint>(
        segments: [(String, T)],
        colors: [Color] = []
    ) -> [SCChartSectorSegment] {
        segments.enumerated().map { index, segment in
            SCChartSectorSegment(
                title: segment.0,
                value: Double(segment.1),
                color: colors[safe: index]
            )
        }
    }

    static func make<T: BinaryInteger>(
        segments: [(String, T)],
        colors: [Color] = []
    ) -> [SCChartSectorSegment] {
        segments.enumerated().map { index, segment in
            SCChartSectorSegment(
                title: segment.0,
                value: Double(segment.1),
                color: colors[safe: index]
            )
        }
    }
}
