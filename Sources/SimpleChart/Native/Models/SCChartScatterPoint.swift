//
//  SCChartScatterPoint.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Foundation

/// Represents a single scatter-plot point with optional label metadata.
public struct SCChartScatterPoint: Identifiable, Equatable {
    public let id: String
    public let x: Double
    public let y: Double
    public let label: String?

    /// Creates a scatter point from explicit x/y coordinates and optional label text.
    public init(id: String, x: Double, y: Double, label: String? = nil) {
        self.id = id
        self.x = x
        self.y = y
        self.label = label
    }
}

public extension SCChartScatterPoint {
    static func make<T: BinaryFloatingPoint, U: BinaryFloatingPoint>(
        points: [(T, U)],
        labels: [String]? = nil
    ) -> [SCChartScatterPoint] {
        points.enumerated().map { index, point in
            SCChartScatterPoint(
                id: "\(index)",
                x: Double(point.0),
                y: Double(point.1),
                label: labels?[safe: index]
            )
        }
    }

    static func make<T: BinaryInteger, U: BinaryInteger>(
        points: [(T, U)],
        labels: [String]? = nil
    ) -> [SCChartScatterPoint] {
        points.enumerated().map { index, point in
            SCChartScatterPoint(
                id: "\(index)",
                x: Double(point.0),
                y: Double(point.1),
                label: labels?[safe: index]
            )
        }
    }

    static func make<T: BinaryFloatingPoint, U: BinaryFloatingPoint>(
        labeledPoints: [(String, T, U)]
    ) -> [SCChartScatterPoint] {
        labeledPoints.enumerated().map { index, point in
            SCChartScatterPoint(
                id: "\(index)",
                x: Double(point.1),
                y: Double(point.2),
                label: point.0
            )
        }
    }
}
