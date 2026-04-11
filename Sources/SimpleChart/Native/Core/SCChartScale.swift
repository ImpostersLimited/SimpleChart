//
//  SCChartScale.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Foundation

public struct SCChartScale: Equatable {
    public let xVisibleDomain: SCChartVisibleDomain?
    public let yDomain: SCChartDomain?
    public let foregroundStyleScale: SCChartForegroundStyleScale?

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

    static func visible(x domain: SCChartVisibleDomain) -> SCChartScale {
        SCChartScale(xVisibleDomain: domain)
    }

    static func y(_ domain: SCChartDomain) -> SCChartScale {
        SCChartScale(yDomain: domain)
    }

    static func foregroundStyleScale(_ scale: SCChartForegroundStyleScale) -> SCChartScale {
        SCChartScale(foregroundStyleScale: scale)
    }

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
