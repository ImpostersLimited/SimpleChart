//
//  SCChartAxesStyle.swift
//
//
//  Created by Codex on 2026-04-09.
//

import SwiftUI

/// Shared axis and grid configuration used by the ready-made native wrappers.
public struct SCChartAxesStyle: Equatable {
    public let showXAxis: Bool
    public let showYAxis: Bool
    public let showGrid: Bool
    public let showYAxisLabels: Bool
    public let xLegend: String
    public let yLegend: String
    public let xLegendColor: Color
    public let yLegendColor: Color
    public let yAxisFigureColor: Color
    public let yAxisFigureFontFactor: Double
    public let intervalLineWidth: CGFloat
    public let intervalColor: Color
    public let preferredIntervalCount: Int

    /// Creates an axis style that can be translated into the lower-level `SCChartAxis` helper types.
    public init(
        showXAxis: Bool = false,
        showYAxis: Bool = false,
        showGrid: Bool = false,
        showYAxisLabels: Bool = false,
        xLegend: String = "",
        yLegend: String = "",
        xLegendColor: Color = .primary,
        yLegendColor: Color = .primary,
        yAxisFigureColor: Color = .secondary,
        yAxisFigureFontFactor: Double = 0.06667,
        intervalLineWidth: CGFloat = 0.5,
        intervalColor: Color = .secondary,
        preferredIntervalCount: Int = 3
    ) {
        self.showXAxis = showXAxis
        self.showYAxis = showYAxis
        self.showGrid = showGrid
        self.showYAxisLabels = showYAxisLabels
        self.xLegend = xLegend
        self.yLegend = yLegend
        self.xLegendColor = xLegendColor
        self.yLegendColor = yLegendColor
        self.yAxisFigureColor = yAxisFigureColor
        self.yAxisFigureFontFactor = yAxisFigureFontFactor
        self.intervalLineWidth = intervalLineWidth
        self.intervalColor = intervalColor
        self.preferredIntervalCount = preferredIntervalCount
    }
}

public extension SCChartAxesStyle {
    /// Hides axes and grid lines, suitable for sparkline-like charts.
    static let minimal = SCChartAxesStyle()

    /// Returns a labeled axis preset with optional grid lines and interval count.
    static func standard(
        x: String = "",
        y: String = "",
        showGrid: Bool = true,
        preferredIntervalCount: Int = 3
    ) -> SCChartAxesStyle {
        SCChartAxesStyle(
            showXAxis: true,
            showYAxis: true,
            showGrid: showGrid,
            showYAxisLabels: true,
            xLegend: x,
            yLegend: y,
            preferredIntervalCount: preferredIntervalCount
        )
    }

    /// Converts the high-level x-axis style into the lower-level axis helper used by composed charts.
    var xAxis: SCChartAxis {
        if showXAxis || showGrid {
            return .x(
                title: xLegend,
                titleColor: xLegendColor,
                desiredCount: preferredIntervalCount,
                showGrid: showGrid,
                showTicks: showXAxis,
                showLabels: showXAxis,
                lineWidth: intervalLineWidth,
                lineColor: intervalColor,
                labelColor: xLegendColor
            )
        }

        return .hidden
    }

    /// Converts the high-level y-axis style into the lower-level axis helper used by composed charts.
    var yAxis: SCChartAxis {
        if showYAxis || showGrid || showYAxisLabels {
            return .y(
                title: yLegend,
                titleColor: yLegendColor,
                desiredCount: preferredIntervalCount,
                showGrid: showGrid,
                showTicks: showYAxis,
                showLabels: showYAxisLabels,
                lineWidth: intervalLineWidth,
                lineColor: intervalColor,
                labelColor: yAxisFigureColor
            )
        }

        return .hidden
    }
}
