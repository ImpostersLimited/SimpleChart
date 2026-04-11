//
//  SCChart3DPoint.swift
//
//
//  Created by Codex on 2026-04-10.
//

import Foundation

/// Represents a single point in 3D chart space.
public struct SCChart3DPoint: Identifiable, Equatable {
    public let id: String
    public let x: Double
    public let y: Double
    public let z: Double
    public let label: String?

    /// Creates a 3D point with optional label metadata.
    public init(
        id: String? = nil,
        x: Double,
        y: Double,
        z: Double,
        label: String? = nil
    ) {
        self.id = id ?? "\(x)-\(y)-\(z)"
        self.x = x
        self.y = y
        self.z = z
        self.label = label
    }
}

public extension SCChart3DPoint {
    /// Builds 3D points from floating-point tuples and optional parallel labels.
    static func make<T: BinaryFloatingPoint, U: BinaryFloatingPoint, V: BinaryFloatingPoint>(
        points: [(T, U, V)],
        labels: [String]? = nil
    ) -> [SCChart3DPoint] {
        points.enumerated().map { index, point in
            SCChart3DPoint(
                id: "point-3d-\(index)",
                x: Double(point.0),
                y: Double(point.1),
                z: Double(point.2),
                label: labels?[safe: index]
            )
        }
    }

    /// Builds 3D points from integer tuples and optional parallel labels.
    static func make<T: BinaryInteger, U: BinaryInteger, V: BinaryInteger>(
        points: [(T, U, V)],
        labels: [String]? = nil
    ) -> [SCChart3DPoint] {
        points.enumerated().map { index, point in
            SCChart3DPoint(
                id: "point-3d-\(index)",
                x: Double(point.0),
                y: Double(point.1),
                z: Double(point.2),
                label: labels?[safe: index]
            )
        }
    }
}
