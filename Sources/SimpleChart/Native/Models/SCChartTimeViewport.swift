//
//  SCChartTimeViewport.swift
//
//
//  Created by Codex on 2026-04-13.
//

import Foundation

/// Represents a date-based x-domain window used for scrolling and zoom coordination.
public struct SCChartTimeViewport: Equatable {
    public let startDate: Date
    public let endDate: Date

    /// Creates a viewport from explicit start and end dates.
    public init(startDate: Date, endDate: Date) {
        self.startDate = min(startDate, endDate)
        self.endDate = max(startDate, endDate)
    }

    /// The viewport expressed as a closed date range.
    public var range: ClosedRange<Date> {
        startDate...endDate
    }

    /// The time span covered by the viewport in seconds.
    public var length: TimeInterval {
        endDate.timeIntervalSince(startDate)
    }

    /// Creates a viewport that starts at a date and extends for a duration in seconds.
    public static func starting(at startDate: Date, duration: TimeInterval) -> SCChartTimeViewport {
        SCChartTimeViewport(
            startDate: startDate,
            endDate: startDate.addingTimeInterval(max(duration, 0))
        )
    }

    /// Creates a viewport centered on a specific date for a duration in seconds.
    public static func centered(at center: Date, duration: TimeInterval) -> SCChartTimeViewport {
        let safeDuration = max(duration, 0)
        let halfDuration = safeDuration / 2
        return SCChartTimeViewport(
            startDate: center.addingTimeInterval(-halfDuration),
            endDate: center.addingTimeInterval(halfDuration)
        )
    }

    /// Returns a viewport moved to a new start date while keeping the same duration.
    public func shifted(to startDate: Date) -> SCChartTimeViewport {
        .starting(at: startDate, duration: length)
    }

    /// Clamps the viewport so it fits entirely inside a larger date range.
    public func clamped(to bounds: ClosedRange<Date>) -> SCChartTimeViewport {
        guard bounds.lowerBound <= bounds.upperBound else { return self }
        let boundsLength = bounds.upperBound.timeIntervalSince(bounds.lowerBound)
        let effectiveLength = min(length, boundsLength)
        let latestStartDate = bounds.upperBound.addingTimeInterval(-effectiveLength)
        let proposedStartDate = min(
            max(startDate, bounds.lowerBound),
            latestStartDate
        )
        return .starting(at: proposedStartDate, duration: effectiveLength)
    }

    /// Returns a zoomed viewport around an optional center and optional outer bounds.
    public func zoomed(
        by factor: Double,
        centeredAt center: Date? = nil,
        within bounds: ClosedRange<Date>? = nil
    ) -> SCChartTimeViewport {
        let safeFactor = max(factor, 0.0001)
        let targetCenter = center ?? startDate.addingTimeInterval(length / 2)
        let zoomed = SCChartTimeViewport.centered(at: targetCenter, duration: length / safeFactor)
        if let bounds {
            return zoomed.clamped(to: bounds)
        }
        return zoomed
    }
}
