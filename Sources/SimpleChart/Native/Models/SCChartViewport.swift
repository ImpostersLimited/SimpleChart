//
//  SCChartViewport.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Foundation

/// Represents a numeric x-domain window used for scrolling and zoom coordination.
public struct SCChartViewport: Equatable {
    public let lowerBound: Double
    public let upperBound: Double

    /// Creates a viewport from explicit lower and upper bounds.
    public init(lowerBound: Double, upperBound: Double) {
        self.lowerBound = min(lowerBound, upperBound)
        self.upperBound = max(lowerBound, upperBound)
    }

    /// The viewport expressed as a closed numeric range.
    public var range: ClosedRange<Double> {
        lowerBound...upperBound
    }

    /// The numeric span covered by the viewport.
    public var length: Double {
        upperBound - lowerBound
    }

    /// Creates a viewport that starts at a lower bound and extends for a given length.
    public static func starting(at lowerBound: Double, length: Double) -> SCChartViewport {
        SCChartViewport(lowerBound: lowerBound, upperBound: lowerBound + max(length, 0))
    }

    /// Creates a viewport centered on a specific value.
    public static func centered(at center: Double, length: Double) -> SCChartViewport {
        let effectiveLength = max(length, 0)
        let halfLength = effectiveLength / 2
        return SCChartViewport(
            lowerBound: center - halfLength,
            upperBound: center + halfLength
        )
    }

    /// Returns a viewport moved to a new lower bound while keeping the same length.
    public func shifted(to lowerBound: Double) -> SCChartViewport {
        SCChartViewport(lowerBound: lowerBound, upperBound: lowerBound + length)
    }

    /// Clamps the viewport so it fits entirely inside a larger bounds range.
    public func clamped(to bounds: ClosedRange<Double>) -> SCChartViewport {
        guard bounds.lowerBound <= bounds.upperBound else { return self }
        let effectiveLength = min(length, bounds.upperBound - bounds.lowerBound)
        let proposedLowerBound = min(
            max(lowerBound, bounds.lowerBound),
            bounds.upperBound - effectiveLength
        )
        return SCChartViewport.starting(at: proposedLowerBound, length: effectiveLength)
    }

    /// Returns a zoomed viewport around an optional center and optional outer bounds.
    public func zoomed(
        by factor: Double,
        centeredAt center: Double? = nil,
        within bounds: ClosedRange<Double>? = nil
    ) -> SCChartViewport {
        let safeFactor = max(factor, 0.0001)
        let targetCenter = center ?? ((lowerBound + upperBound) / 2)
        let zoomed = SCChartViewport.centered(at: targetCenter, length: length / safeFactor)
        if let bounds {
            return zoomed.clamped(to: bounds)
        }
        return zoomed
    }
}
