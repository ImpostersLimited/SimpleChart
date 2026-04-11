//
//  SCChartPlotSupport.swift
//
//
//  Created by Codex on 2026-04-10.
//

import CoreGraphics
import Foundation

public enum SCChartPlotStacking: String, Codable, Equatable {
    case standard
    case normalized
    case center
    case unstacked
}

public enum SCChartPlotDimension: Equatable {
    case automatic
    case fixed(CGFloat)
    case ratio(CGFloat)
    case inset(CGFloat)

    public static let auto = SCChartPlotDimension.automatic
}
