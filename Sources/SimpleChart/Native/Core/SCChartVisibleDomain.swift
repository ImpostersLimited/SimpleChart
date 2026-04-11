//
//  SCChartVisibleDomain.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Foundation

public struct SCChartVisibleDomain: Equatable, Codable {
    public let length: Double

    public init(length: Double) {
        self.length = max(length, 0.0001)
    }

    public static func points(_ count: Int) -> SCChartVisibleDomain {
        SCChartVisibleDomain(length: Double(max(count, 1)))
    }

    public static func seconds(_ duration: TimeInterval) -> SCChartVisibleDomain {
        SCChartVisibleDomain(length: duration)
    }

    public static func minutes(_ duration: Double) -> SCChartVisibleDomain {
        SCChartVisibleDomain(length: duration * 60)
    }

    public static func hours(_ duration: Double) -> SCChartVisibleDomain {
        SCChartVisibleDomain(length: duration * 60 * 60)
    }

    public static func days(_ duration: Double) -> SCChartVisibleDomain {
        SCChartVisibleDomain(length: duration * 60 * 60 * 24)
    }

    public static func weeks(_ duration: Double) -> SCChartVisibleDomain {
        .days(duration * 7)
    }

    public static func analytics(points count: Int = 14) -> SCChartVisibleDomain {
        .points(count)
    }

    public static func finance(tradingDays count: Int = 5) -> SCChartVisibleDomain {
        .points(count)
    }
}
