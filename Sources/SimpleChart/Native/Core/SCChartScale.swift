//
//  SCChartScale.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Foundation

/// Bundles optional x-domain, y-domain, and foreground-style scaling for composed charts.
public struct SCChartScale: Equatable {
    public let xVisibleDomain: SCChartVisibleDomain?
    public let yDomain: SCChartDomain?
    public let foregroundStyleScale: SCChartForegroundStyleScale?

    /// Creates a scale bundle from visible-domain, y-domain, and style-scale components.
    public init(
        xVisibleDomain: SCChartVisibleDomain? = nil,
        yDomain: SCChartDomain? = nil,
        foregroundStyleScale: SCChartForegroundStyleScale? = nil
    ) {
        self.xVisibleDomain = xVisibleDomain
        self.yDomain = yDomain
        self.foregroundStyleScale = foregroundStyleScale
    }
}

public extension SCChartScale {
    static let automatic = SCChartScale()

    /// Returns a scale bundle with only an x visible-domain override.
    static func visible(x domain: SCChartVisibleDomain) -> SCChartScale {
        SCChartScale(xVisibleDomain: domain)
    }

    /// Returns a scale bundle with only a y-domain override.
    static func y(_ domain: SCChartDomain) -> SCChartScale {
        SCChartScale(yDomain: domain)
    }

    /// Returns a scale bundle with only a foreground-style scale override.
    static func foregroundStyleScale(_ scale: SCChartForegroundStyleScale) -> SCChartScale {
        SCChartScale(foregroundStyleScale: scale)
    }

    /// Returns a scale bundle with a fixed y-domain range.
    static func fixed(y range: ClosedRange<Double>) -> SCChartScale {
        SCChartScale(
            yDomain: SCChartDomain(
                lowerBound: range.lowerBound,
                upperBound: range.upperBound,
                actualLowerBound: range.lowerBound,
                actualUpperBound: range.upperBound
            )
        )
    }
}
