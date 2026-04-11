//
//  SCComposedChart.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Charts
import SwiftUI

/// A wrapper that renders an arbitrary `SCChartComposition` using the native Swift Charts backend.
public struct SCComposedChart: View {
    public let composition: SCChartComposition

    /// Creates a composed chart from a prebuilt composition object.
    public init(composition: SCChartComposition) {
        self.composition = composition
    }

    /// Creates a composed chart directly from helper-layer marks, overlays, axes, and scale inputs.
    public init(
        marks: [SCChartMark],
        overlays: [SCChartOverlay] = [],
        axesStyle: SCChartAxesStyle = .minimal,
        xAxis: SCChartAxis? = nil,
        yAxis: SCChartAxis? = nil,
        legend: SCChartLegend = .hidden,
        plotStyle: SCChartPlotStyle = .standard,
        domain: SCChartDomain? = nil,
        scale: SCChartScale? = nil,
        foregroundStyleScale: SCChartForegroundStyleScale? = nil,
        baseZero: Bool = false,
        paddingRatio: Double = 0.03
    ) {
        let resolvedScale: SCChartScale
        if let scale {
            let domainAdjustedScale = scale.yDomain == nil && domain != nil
                ? SCChartScale(
                    xVisibleDomain: scale.xVisibleDomain,
                    yDomain: domain,
                    foregroundStyleScale: scale.foregroundStyleScale
                )
                : scale

            if let foregroundStyleScale, domainAdjustedScale.foregroundStyleScale == nil {
                resolvedScale = SCChartScale(
                    xVisibleDomain: domainAdjustedScale.xVisibleDomain,
                    yDomain: domainAdjustedScale.yDomain,
                    foregroundStyleScale: foregroundStyleScale
                )
            } else {
                resolvedScale = domainAdjustedScale
            }
        } else {
            resolvedScale = domain.map {
                SCChartScale(yDomain: $0, foregroundStyleScale: foregroundStyleScale)
            } ?? SCChartScale(foregroundStyleScale: foregroundStyleScale)
        }

        self.composition = SCChartComposition(
            marks: marks,
            overlays: overlays,
            axesStyle: axesStyle,
            xAxis: xAxis,
            yAxis: yAxis,
            legend: legend,
            plotStyle: plotStyle,
            scale: resolvedScale,
            foregroundStyleScale: foregroundStyleScale,
            baseZero: baseZero,
            paddingRatio: paddingRatio
        )
    }

    /// The marks rendered by the chart.
    public var marks: [SCChartMark] { composition.marks }
    /// The overlays rendered above the chart's primary marks.
    public var overlays: [SCChartOverlay] { composition.overlays }
    /// The high-level axis style associated with the composition.
    public var axesStyle: SCChartAxesStyle { composition.axesStyle }
    /// The resolved x-axis, falling back to the axis style when no explicit axis is supplied.
    public var xAxis: SCChartAxis { composition.xAxis ?? composition.axesStyle.xAxis }
    /// The resolved y-axis, falling back to the axis style when no explicit axis is supplied.
    public var yAxis: SCChartAxis { composition.yAxis ?? composition.axesStyle.yAxis }
    /// The legend behavior for the composed chart.
    public var legend: SCChartLegend { composition.legend }
    /// The plot-area styling for the composed chart.
    public var plotStyle: SCChartPlotStyle { composition.plotStyle }
    /// The resolved scale configuration for the composed chart.
    public var scale: SCChartScale { composition.scale }
    /// The optional foreground style scale applied to categorical series names.
    public var foregroundStyleScale: SCChartForegroundStyleScale? { composition.foregroundStyleScale }
    /// The explicit y-domain when one has been supplied through the scale helper layer.
    public var domain: SCChartDomain? { composition.scale.yDomain }
    /// Whether an auto-derived domain should be expanded to include zero.
    public var baseZero: Bool { composition.baseZero }
    /// The padding ratio applied when the chart auto-resolves its y-domain.
    public var paddingRatio: Double { composition.paddingRatio }

    public var body: some View {
        SCNativeChartContainer(
            axesStyle: axesStyle,
            xAxis: composition.xAxis,
            yAxis: composition.yAxis,
            legend: composition.legend,
            plotStyle: composition.plotStyle
        ) {
            Chart {
                ForEach(Array(marks.enumerated()), id: \.offset) { _, mark in
                    chartContent(for: mark)
                }

                ForEach(Array(overlays.enumerated()), id: \.offset) { _, overlay in
                    overlayContent(for: overlay)
                }
            }
            .scChartYScale(scale, fallbackDomain: resolvedDomain)
            .scChartXScale(scale)
            .scChartForegroundStyleScale(foregroundStyleScale)
            .scChartAxes(xAxis: xAxis, yAxis: yAxis)
        }
    }

    /// The final y-domain used by the chart after considering explicit scale input and inferred data bounds.
    private var resolvedDomain: SCChartDomain? {
        if let domain {
            return domain
        }
        let values = marks.flatMap(\.inferredValues) + overlays.flatMap(\.inferredValues)
        guard !values.isEmpty else { return nil }
        return .auto(values: values, baseZero: baseZero, paddingRatio: paddingRatio)
    }

    private var categoricalOverlayLabels: [String] {
        let labels = marks.flatMap { mark -> [String] in
            switch mark {
            case let .line(points, _), let .area(points, _), let .bar(points, _):
                return points.map(\.plottedXValue)
            case let .range(points, _):
                return points.map(\.plottedXValue)
            case .point,
                 .linePlot,
                 .areaPlot,
                 .barPlot,
                 .pointPlot,
                 .rectangle,
                 .rectanglePlot,
                 .sector,
                 .rule:
                return []
            }
        }

        return Array(NSOrderedSet(array: labels)) as? [String] ?? labels
    }

    @ChartContentBuilder
    private func chartContent(for mark: SCChartMark) -> some ChartContent {
        switch mark {
        case let .line(points, style):
            ForEach(points) { point in
                LineMark(
                    x: .value("Category", point.plottedXValue),
                    y: .value("Value", point.value)
                )
                .foregroundStyle(style.foregroundGradient)
                .lineStyle(StrokeStyle(lineWidth: style.strokeWidth))
                .interpolationMethod(style.chartInterpolationMethod)
            }
        case let .area(points, style):
            ForEach(points) { point in
                AreaMark(
                    x: .value("Category", point.plottedXValue),
                    y: .value("Value", point.value)
                )
                .foregroundStyle(style.foregroundGradient)
                .interpolationMethod(style.chartInterpolationMethod)

                LineMark(
                    x: .value("Category", point.plottedXValue),
                    y: .value("Value", point.value)
                )
                .foregroundStyle(style.foregroundGradient)
                .lineStyle(StrokeStyle(lineWidth: style.strokeWidth))
                .interpolationMethod(style.chartInterpolationMethod)
            }
        case let .bar(points, style):
            ForEach(points) { point in
                BarMark(
                    x: .value("Category", point.plottedXValue),
                    y: .value("Value", point.value)
                )
                .foregroundStyle(style.foregroundGradient)
            }
        case let .point(points, style):
            ForEach(points) { point in
                PointMark(
                    x: .value("X", point.x),
                    y: .value("Y", point.y)
                )
                .foregroundStyle(style.foregroundGradient)
                .symbolSize(style.markSize)
            }
        case let .linePlot(points, style):
            ForEach(points) { point in
                LineMark(
                    x: .value("X", point.x),
                    y: .value("Y", point.y)
                )
                .foregroundStyle(style.foregroundGradient)
                .lineStyle(StrokeStyle(lineWidth: style.strokeWidth))
                .interpolationMethod(style.chartInterpolationMethod)
            }
        case let .areaPlot(points, style, _):
            ForEach(points) { point in
                AreaMark(
                    x: .value("X", point.x),
                    y: .value("Y", point.y)
                )
                .foregroundStyle(style.foregroundGradient)
                .interpolationMethod(style.chartInterpolationMethod)
            }
        case let .barPlot(points, style, _, _, _):
            ForEach(points) { point in
                BarMark(
                    x: .value("X", point.x),
                    y: .value("Y", point.y)
                )
                .foregroundStyle(style.foregroundGradient)
            }
        case let .pointPlot(points, style):
            ForEach(points) { point in
                PointMark(
                    x: .value("X", point.x),
                    y: .value("Y", point.y)
                )
                .foregroundStyle(style.foregroundGradient)
                .symbolSize(style.markSize)
            }
        case let .range(points, style):
            ForEach(points) { point in
                if style.strokeOnly {
                    RuleMark(
                        x: .value("Category", point.plottedXValue),
                        yStart: .value("Lower", point.lower),
                        yEnd: .value("Upper", point.upper)
                    )
                    .foregroundStyle(style.foregroundGradient)
                    .lineStyle(StrokeStyle(lineWidth: max(style.strokeWidth, 8), lineCap: .round))
                } else {
                    BarMark(
                        x: .value("Category", point.plottedXValue),
                        yStart: .value("Lower", point.lower),
                        yEnd: .value("Upper", point.upper),
                        width: .ratio(0.55)
                    )
                    .foregroundStyle(style.foregroundGradient)
                }
            }
        case let .rectangle(rectangles, style):
            ForEach(rectangles) { rectangle in
                RectangleMark(
                    xStart: .value("Start X", rectangle.xStart),
                    xEnd: .value("End X", rectangle.xEnd),
                    yStart: .value("Start Y", rectangle.yStart),
                    yEnd: .value("End Y", rectangle.yEnd)
                )
                .foregroundStyle(rectangle.color ?? style.primaryColor)
                .annotation(
                    position: rectangle.annotation?.anchor.chartAnnotationPosition ?? .top,
                    alignment: rectangle.annotation?.alignment ?? .center
                ) {
                    if let annotation = rectangle.annotation {
                        SCChartAnnotationLabelView(annotation: annotation)
                    }
                }
            }
        case let .rectanglePlot(rectangles, style, _, _):
            ForEach(rectangles) { rectangle in
                RectangleMark(
                    xStart: .value("Start X", rectangle.xStart),
                    xEnd: .value("End X", rectangle.xEnd),
                    yStart: .value("Start Y", rectangle.yStart),
                    yEnd: .value("End Y", rectangle.yEnd)
                )
                .foregroundStyle(style.foregroundGradient)
            }
        case let .sector(segments, style):
            if #available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *) {
                ForEach(Array(segments.enumerated()), id: \.element.id) { index, segment in
                    SectorMark(
                        angle: .value("Value", segment.value),
                        innerRadius: .ratio(0)
                    )
                    .foregroundStyle(segment.color ?? style.colors[safe: index] ?? style.primaryColor)
                }
            }
        case let .rule(referenceLine):
            referenceLineContent(referenceLine)
        }
    }



    @ChartContentBuilder
    private func overlayContent(for overlay: SCChartOverlay) -> some ChartContent {
        switch overlay {
        case let .referenceLine(referenceLine):
            referenceLineContent(referenceLine)
        case let .referenceLines(referenceLines):
            ForEach(referenceLines) { referenceLine in
                referenceLineContent(referenceLine)
            }
        case let .band(band):
            bandContent(band)
        case let .bands(bands):
            ForEach(bands) { band in
                bandContent(band)
            }
        case let .pointLabels(points, color, anchor):
            ForEach(points) { point in
                PointMark(
                    x: .value("Category", point.plottedXValue),
                    y: .value("Value", point.value)
                )
                .foregroundStyle(.clear)
                .annotation(position: anchor.chartAnnotationPosition) {
                    SCChartAnnotationLabelView(
                        annotation: .caption(point.xLabel ?? point.id, color: color, anchor: anchor)
                    )
                }
            }
        }
    }

    @ChartContentBuilder
    private func referenceLineContent(_ referenceLine: SCChartReferenceLine) -> some ChartContent {
        RuleMark(y: .value(referenceLine.title, referenceLine.value))
            .foregroundStyle(referenceLine.color)
            .lineStyle(referenceLine.strokeStyle)
            .annotation(
                position: (referenceLine.annotation ?? .lineLabel(referenceLine.title, color: referenceLine.color)).anchor.chartAnnotationPosition,
                alignment: (referenceLine.annotation ?? .lineLabel(referenceLine.title, color: referenceLine.color)).alignment
            ) {
                let annotation = referenceLine.annotation ?? .lineLabel(referenceLine.title, color: referenceLine.color)
                SCChartAnnotationLabelView(annotation: annotation)
            }
    }

    @ChartContentBuilder
    private func bandContent(_ band: SCChartBand) -> some ChartContent {
        if !categoricalOverlayLabels.isEmpty {
            ForEach(categoricalOverlayLabels, id: \.self) { label in
                BarMark(
                    x: .value("Category", label),
                    yStart: .value("Lower", band.lower),
                    yEnd: .value("Upper", band.upper),
                    width: .ratio(0.96)
                )
                .foregroundStyle(band.color.opacity(band.opacity))
            }

            if let annotation = band.annotation ?? defaultBandAnnotation(for: band) {
                RuleMark(y: .value(band.title, band.upper))
                    .foregroundStyle(.clear)
                    .annotation(
                        position: annotation.anchor.chartAnnotationPosition,
                        alignment: annotation.alignment
                    ) {
                        SCChartAnnotationLabelView(annotation: annotation)
                    }
            }
        }
    }

    private func defaultBandAnnotation(for band: SCChartBand) -> SCChartAnnotation? {
        guard !band.title.isEmpty else { return nil }
        return .lineLabel(band.title, color: band.color)
    }
}
