//
//  SCChartComposition.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Foundation

/// A complete declarative chart description used by `SCComposedChart`.
public struct SCChartComposition: Equatable {
    public let marks: [SCChartMark]
    public let overlays: [SCChartOverlay]
    public let axesStyle: SCChartAxesStyle
    public let xAxis: SCChartAxis?
    public let yAxis: SCChartAxis?
    public let legend: SCChartLegend
    public let plotStyle: SCChartPlotStyle
    public let scale: SCChartScale
    public let foregroundStyleScale: SCChartForegroundStyleScale?
    public let baseZero: Bool
    public let paddingRatio: Double

    /// Creates a composed chart description from marks, overlays, axis configuration, and scale behavior.
    public init(
        marks: [SCChartMark],
        overlays: [SCChartOverlay] = [],
        axesStyle: SCChartAxesStyle = .minimal,
        xAxis: SCChartAxis? = nil,
        yAxis: SCChartAxis? = nil,
        legend: SCChartLegend = .hidden,
        plotStyle: SCChartPlotStyle = .standard,
        scale: SCChartScale = .automatic,
        foregroundStyleScale: SCChartForegroundStyleScale? = nil,
        baseZero: Bool = false,
        paddingRatio: Double = 0.03
    ) {
        self.marks = marks
        self.overlays = overlays
        self.axesStyle = axesStyle
        self.xAxis = xAxis
        self.yAxis = yAxis
        self.legend = legend
        self.plotStyle = plotStyle
        self.scale = scale
        self.foregroundStyleScale = foregroundStyleScale ?? scale.foregroundStyleScale
        self.baseZero = baseZero
        self.paddingRatio = paddingRatio
    }
}
