//
//  SCChartPlotSupport.swift
//
//
//  Created by Codex on 2026-04-10.
//

import CoreGraphics
import Foundation

/// Controls how overlapping plot-based series should stack vertically.
public enum SCChartPlotStacking: String, Codable, Equatable {
    case standard
    case normalized
    case center
    case unstacked
}

/// Describes plot widths, heights, or insets for vectorized plot marks.
public enum SCChartPlotDimension: Equatable {
    case automatic
    case fixed(CGFloat)
    case ratio(CGFloat)
    case inset(CGFloat)

    public static let auto = SCChartPlotDimension.automatic
}
