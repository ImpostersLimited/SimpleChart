//
//  SCChartVisibleDomain.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Foundation

/// Describes how much of a scrollable x-domain should stay visible at once.
public struct SCChartVisibleDomain: Equatable, Codable {
    public let length: Double

    /// Creates a visible-domain window from a raw numeric length.
    public init(length: Double) {
        self.length = max(length, 0.0001)
    }

    /// Creates a visible-domain window measured in categorical points.
    public static func points(_ count: Int) -> SCChartVisibleDomain {
        SCChartVisibleDomain(length: Double(max(count, 1)))
    }

    /// Creates a visible-domain window measured in seconds.
    public static func seconds(_ duration: TimeInterval) -> SCChartVisibleDomain {
        SCChartVisibleDomain(length: duration)
    }

    /// Creates a visible-domain window measured in minutes.
    public static func minutes(_ duration: Double) -> SCChartVisibleDomain {
        SCChartVisibleDomain(length: duration * 60)
    }

    /// Creates a visible-domain window measured in hours.
    public static func hours(_ duration: Double) -> SCChartVisibleDomain {
        SCChartVisibleDomain(length: duration * 60 * 60)
    }

    /// Creates a visible-domain window measured in days.
    public static func days(_ duration: Double) -> SCChartVisibleDomain {
        SCChartVisibleDomain(length: duration * 60 * 60 * 24)
    }

    /// Creates a visible-domain window measured in weeks.
    public static func weeks(_ duration: Double) -> SCChartVisibleDomain {
        .days(duration * 7)
    }

    /// Returns the default analytics-style window size in visible points.
    public static func analytics(points count: Int = 14) -> SCChartVisibleDomain {
        .points(count)
    }

    /// Returns the default finance-style window size in visible trading days.
    public static func finance(tradingDays count: Int = 5) -> SCChartVisibleDomain {
        .points(count)
    }
}
