//
//  SCHoverableCharts.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Charts
import SwiftUI

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
/// A line chart wrapper with pointer-hover inspection support.
public struct SCHoverableLineChart: View {
    public let points: [SCChartPoint]
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?
    public let referenceLines: [SCChartReferenceLine]
    public let inspectionOverlay: SCChartInspectionOverlay
    public let yAxisFormat: SCChartNumericValueFormat

    @Binding private var hoverState: SCChartHoverState?

    /// Creates a hoverable line chart bound to external hover state.
    public init(
        points: [SCChartPoint],
        hoverState: Binding<SCChartHoverState?>,
        seriesStyle: SCChartSeriesStyle = .line(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        referenceLines: [SCChartReferenceLine] = [],
        inspectionOverlay: SCChartInspectionOverlay = .automatic(),
        yAxisFormat: SCChartNumericValueFormat = .automatic
    ) {
        self.points = points
        self._hoverState = hoverState
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain ?? .auto(points: points, baseZero: false)
        self.referenceLines = referenceLines
        self.inspectionOverlay = inspectionOverlay
        self.yAxisFormat = yAxisFormat
    }

    public var body: some View {
        SCNativeChartContainer(axesStyle: axesStyle) {
            Chart(indexedPoints) { entry in
                if hoveredPoint?.point.id == entry.point.id, inspectionOverlay.showsCrosshair {
                    RuleMark(x: .value("Index", entry.index))
                        .foregroundStyle(seriesStyle.primaryColor.opacity(0.45))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 4]))

                    RuleMark(y: .value("Value", entry.point.value))
                        .foregroundStyle(seriesStyle.primaryColor.opacity(0.25))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 4]))
                }

                if seriesStyle.showArea {
                    AreaMark(
                        x: .value("Index", entry.index),
                        y: .value("Value", entry.point.value)
                    )
                    .foregroundStyle(seriesStyle.foregroundGradient)
                    .interpolationMethod(seriesStyle.chartInterpolationMethod)
                }

                LineMark(
                    x: .value("Index", entry.index),
                    y: .value("Value", entry.point.value)
                )
                .foregroundStyle(seriesStyle.foregroundGradient)
                .lineStyle(StrokeStyle(lineWidth: seriesStyle.strokeWidth))
                .interpolationMethod(seriesStyle.chartInterpolationMethod)

                if hoveredPoint?.point.id == entry.point.id, inspectionOverlay.isVisible {
                    PointMark(
                        x: .value("Index", entry.index),
                        y: .value("Value", entry.point.value)
                    )
                    .foregroundStyle(seriesStyle.primaryColor)
                    .symbolSize(max(seriesStyle.markSize, 60))
                    .annotation(position: inspectionOverlay.anchor.chartAnnotationPosition) {
                        hoverOverlayView(
                            hoverState: SCChartHoverState(
                                xLabel: entry.point.plottedXValue,
                                value: entry.point.value
                            )
                        )
                    }
                }

                ForEach(referenceLines) { referenceLine in
                    RuleMark(y: .value(referenceLine.title, referenceLine.value))
                        .foregroundStyle(referenceLine.color)
                        .lineStyle(referenceLine.strokeStyle)
                }
            }
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    SCChartHoverCaptureOverlay(
                        plotFrame: geometry[proxy.plotAreaFrame],
                        onLocation: { location in
                            updateHover(for: location, plotFrame: geometry[proxy.plotAreaFrame])
                        },
                        onEnded: { hoverState = nil }
                    )
                }
            }
            .scChartDomain(domain)
            .scChartIndexedXAxis(labels: points.map(\.plottedXValue), axesStyle: axesStyle)
            .scChartNumericYAxis(axesStyle, format: yAxisFormat)
        }
    }

    private var indexedPoints: [SCIndexedChartPoint] {
        points.enumerated().map { SCIndexedChartPoint(index: $0.offset, point: $0.element) }
    }

    private var hoveredPoint: SCIndexedChartPoint? {
        guard let label = hoverState?.xLabel else { return nil }
        return indexedPoints.first { $0.point.plottedXValue == label }
    }

    private func updateHover(for location: CGPoint, plotFrame: CGRect) {
        guard !points.isEmpty else {
            hoverState = nil
            return
        }

        let localX = location.x - plotFrame.minX
        guard localX >= 0, localX <= plotFrame.width else {
            hoverState = nil
            return
        }

        let fraction = plotFrame.width > 0 ? localX / plotFrame.width : 0
        let index = min(max(Int(round(fraction * CGFloat(max(points.count - 1, 0)))), 0), points.count - 1)
        let point = points[index]
        hoverState = SCChartHoverState(xLabel: point.plottedXValue, value: point.value)
    }

    @ViewBuilder
    private func hoverOverlayView(hoverState: SCChartHoverState) -> some View {
        switch inspectionOverlay {
        case .hidden:
            EmptyView()
        case .pointLabel:
            SCChartAnnotationLabelView(annotation: .valueLabel(hoverState.value, format: yAxisFormat, anchor: inspectionOverlay.anchor))
        case .automatic, .callout, .inspector, .crosshair(_, true):
            SCChartInspectionCallout(selection: hoverState.selection, valueFormat: yAxisFormat)
        case .crosshair(_, false):
            EmptyView()
        }
    }
}

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
/// A bar chart wrapper with pointer-hover inspection support.
public struct SCHoverableBarChart: View {
    public let points: [SCChartPoint]
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?
    public let inspectionOverlay: SCChartInspectionOverlay
    public let yAxisFormat: SCChartNumericValueFormat

    @Binding private var hoverState: SCChartHoverState?

    /// Creates a hoverable bar chart bound to external hover state.
    public init(
        points: [SCChartPoint],
        hoverState: Binding<SCChartHoverState?>,
        seriesStyle: SCChartSeriesStyle = .bar(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        inspectionOverlay: SCChartInspectionOverlay = .automatic(),
        yAxisFormat: SCChartNumericValueFormat = .automatic
    ) {
        self.points = points
        self._hoverState = hoverState
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain ?? .auto(points: points, baseZero: true)
        self.inspectionOverlay = inspectionOverlay
        self.yAxisFormat = yAxisFormat
    }

    public var body: some View {
        SCNativeChartContainer(axesStyle: axesStyle) {
            Chart(indexedPoints) { entry in
                if hoveredPoint?.point.id == entry.point.id, inspectionOverlay.showsCrosshair {
                    RuleMark(x: .value("Index", entry.index))
                        .foregroundStyle(seriesStyle.primaryColor.opacity(0.45))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 4]))

                    RuleMark(y: .value("Value", entry.point.value))
                        .foregroundStyle(seriesStyle.primaryColor.opacity(0.25))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 4]))
                }

                BarMark(
                    x: .value("Index", entry.index),
                    y: .value("Value", entry.point.value)
                )
                .foregroundStyle(seriesStyle.foregroundGradient)
                .annotation(position: inspectionOverlay.anchor.chartAnnotationPosition) {
                    if hoveredPoint?.point.id == entry.point.id, inspectionOverlay.isVisible {
                        hoverOverlayView(
                            hoverState: SCChartHoverState(
                                xLabel: entry.point.plottedXValue,
                                value: entry.point.value
                            )
                        )
                    }
                }
            }
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    SCChartHoverCaptureOverlay(
                        plotFrame: geometry[proxy.plotAreaFrame],
                        onLocation: { location in
                            updateHover(for: location, plotFrame: geometry[proxy.plotAreaFrame])
                        },
                        onEnded: { hoverState = nil }
                    )
                }
            }
            .scChartDomain(domain)
            .scChartIndexedXAxis(labels: points.map(\.plottedXValue), axesStyle: axesStyle)
            .scChartNumericYAxis(axesStyle, format: yAxisFormat)
        }
    }

    private var indexedPoints: [SCIndexedChartPoint] {
        points.enumerated().map { SCIndexedChartPoint(index: $0.offset, point: $0.element) }
    }

    private var hoveredPoint: SCIndexedChartPoint? {
        guard let label = hoverState?.xLabel else { return nil }
        return indexedPoints.first { $0.point.plottedXValue == label }
    }

    private func updateHover(for location: CGPoint, plotFrame: CGRect) {
        guard !points.isEmpty else {
            hoverState = nil
            return
        }

        let localX = location.x - plotFrame.minX
        guard localX >= 0, localX <= plotFrame.width else {
            hoverState = nil
            return
        }

        let fraction = plotFrame.width > 0 ? localX / plotFrame.width : 0
        let index = min(max(Int(round(fraction * CGFloat(max(points.count - 1, 0)))), 0), points.count - 1)
        let point = points[index]
        hoverState = SCChartHoverState(xLabel: point.plottedXValue, value: point.value)
    }

    @ViewBuilder
    private func hoverOverlayView(hoverState: SCChartHoverState) -> some View {
        switch inspectionOverlay {
        case .hidden:
            EmptyView()
        case .pointLabel:
            SCChartAnnotationLabelView(annotation: .valueLabel(hoverState.value, format: yAxisFormat, anchor: inspectionOverlay.anchor))
        case .automatic, .callout, .inspector, .crosshair(_, true):
            SCChartInspectionCallout(selection: hoverState.selection, valueFormat: yAxisFormat)
        case .crosshair(_, false):
            EmptyView()
        }
    }
}

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
/// A scatter chart wrapper with pointer-hover inspection support.
public struct SCHoverableScatterChart: View {
    public let points: [SCChartScatterPoint]
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?
    public let inspectionOverlay: SCChartInspectionOverlay
    public let yAxisFormat: SCChartNumericValueFormat

    @Binding private var hoverState: SCChartHoverState?

    /// Creates a hoverable scatter chart bound to external hover state.
    public init(
        points: [SCChartScatterPoint],
        hoverState: Binding<SCChartHoverState?>,
        seriesStyle: SCChartSeriesStyle = .scatter(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        inspectionOverlay: SCChartInspectionOverlay = .automatic(),
        yAxisFormat: SCChartNumericValueFormat = .automatic
    ) {
        self.points = points
        self._hoverState = hoverState
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain ?? .auto(values: points.map(\.y))
        self.inspectionOverlay = inspectionOverlay
        self.yAxisFormat = yAxisFormat
    }

    public var body: some View {
        SCNativeChartContainer(axesStyle: axesStyle) {
            Chart(points) { point in
                if hoveredPoint?.id == point.id, inspectionOverlay.showsCrosshair {
                    RuleMark(x: .value("X", point.x))
                        .foregroundStyle(seriesStyle.primaryColor.opacity(0.45))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 4]))

                    RuleMark(y: .value("Y", point.y))
                        .foregroundStyle(seriesStyle.primaryColor.opacity(0.25))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 4]))
                }

                PointMark(
                    x: .value("X", point.x),
                    y: .value("Y", point.y)
                )
                .foregroundStyle(seriesStyle.foregroundGradient)
                .symbolSize(max(seriesStyle.markSize, hoveredPoint?.id == point.id ? 80 : seriesStyle.markSize))
                .annotation(position: inspectionOverlay.anchor.chartAnnotationPosition) {
                    if hoveredPoint?.id == point.id, inspectionOverlay.isVisible {
                        hoverOverlayView(
                            hoverState: SCChartHoverState(
                                xLabel: point.label ?? point.x.formatted(.number.precision(.fractionLength(2))),
                                value: point.y
                            )
                        )
                    }
                }
            }
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    SCChartHoverCaptureOverlay(
                        plotFrame: geometry[proxy.plotAreaFrame],
                        onLocation: { location in
                            updateHover(for: location, plotFrame: geometry[proxy.plotAreaFrame])
                        },
                        onEnded: { hoverState = nil }
                    )
                }
            }
            .scChartDomain(domain)
            .scChartAxes(axesStyle)
        }
    }

    private var hoveredPoint: SCChartScatterPoint? {
        guard let label = hoverState?.xLabel else { return nil }
        return points.first {
            ($0.label ?? $0.x.formatted(.number.precision(.fractionLength(2)))) == label
        }
    }

    private func updateHover(for location: CGPoint, plotFrame: CGRect) {
        guard !points.isEmpty else {
            hoverState = nil
            return
        }

        let localX = location.x - plotFrame.minX
        guard localX >= 0, localX <= plotFrame.width else {
            hoverState = nil
            return
        }

        let minX = points.map(\.x).min() ?? 0
        let maxX = points.map(\.x).max() ?? minX
        let range = max(maxX - minX, .leastNonzeroMagnitude)
        let fraction = plotFrame.width > 0 ? Double(localX / plotFrame.width) : 0
        let targetX = minX + (range * fraction)

        guard let point = points.min(by: { abs($0.x - targetX) < abs($1.x - targetX) }) else {
            hoverState = nil
            return
        }

        hoverState = SCChartHoverState(
            xLabel: point.label ?? point.x.formatted(.number.precision(.fractionLength(2))),
            value: point.y
        )
    }

    @ViewBuilder
    private func hoverOverlayView(hoverState: SCChartHoverState) -> some View {
        switch inspectionOverlay {
        case .hidden:
            EmptyView()
        case .pointLabel:
            SCChartAnnotationLabelView(annotation: .valueLabel(hoverState.value, format: yAxisFormat, anchor: inspectionOverlay.anchor))
        case .automatic, .callout, .inspector, .crosshair(_, true):
            SCChartInspectionCallout(selection: hoverState.selection, valueFormat: yAxisFormat)
        case .crosshair(_, false):
            EmptyView()
        }
    }
}
