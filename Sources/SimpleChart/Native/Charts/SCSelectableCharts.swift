//
//  SCSelectableCharts.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Charts
import SwiftUI

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
/// A line chart wrapper with native point selection and inspection support.
public struct SCSelectableLineChart: View {
    public let points: [SCChartPoint]
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?
    public let referenceLines: [SCChartReferenceLine]
    public let inspectionOverlay: SCChartInspectionOverlay
    public let gestureConfiguration: SCChartGestureConfiguration
    public let yAxisFormat: SCChartNumericValueFormat

    @Binding private var selection: SCChartSelection?

    /// Creates a selectable line chart bound directly to an optional selection.
    public init(
        points: [SCChartPoint],
        selection: Binding<SCChartSelection?>,
        seriesStyle: SCChartSeriesStyle = .line(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        referenceLines: [SCChartReferenceLine] = [],
        inspectionOverlay: SCChartInspectionOverlay = .automatic(),
        gestureConfiguration: SCChartGestureConfiguration = .selectionOnly,
        yAxisFormat: SCChartNumericValueFormat = .automatic
    ) {
        self.points = points
        self._selection = selection
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain ?? .auto(points: points, baseZero: false)
        self.referenceLines = referenceLines
        self.inspectionOverlay = inspectionOverlay
        self.gestureConfiguration = gestureConfiguration
        self.yAxisFormat = yAxisFormat
    }

    /// Creates a selectable line chart bound to the shared selection-state helper.
    public init(
        points: [SCChartPoint],
        selectionState: Binding<SCChartSelectionState>,
        seriesStyle: SCChartSeriesStyle = .line(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        referenceLines: [SCChartReferenceLine] = [],
        inspectionOverlay: SCChartInspectionOverlay = .automatic(),
        gestureConfiguration: SCChartGestureConfiguration = .selectionOnly,
        yAxisFormat: SCChartNumericValueFormat = .automatic
    ) {
        self.init(
            points: points,
            selection: Binding(
                get: { selectionState.wrappedValue.selection },
                set: { selectionState.wrappedValue = SCChartSelectionState(selection: $0) }
            ),
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            domain: domain,
            referenceLines: referenceLines,
            inspectionOverlay: inspectionOverlay,
            gestureConfiguration: gestureConfiguration,
            yAxisFormat: yAxisFormat
        )
    }

    public var body: some View {
        SCNativeChartContainer(axesStyle: axesStyle) {
            Chart(indexedPoints) { entry in
                if selectedPoint?.point.id == entry.point.id, inspectionOverlay.showsCrosshair {
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

                if selectedPoint?.point.id == entry.point.id, inspectionOverlay.isVisible {
                    PointMark(
                        x: .value("Index", entry.index),
                        y: .value("Value", entry.point.value)
                    )
                    .foregroundStyle(seriesStyle.primaryColor)
                    .symbolSize(max(seriesStyle.markSize, 60))
                    .annotation(position: inspectionOverlay.anchor.chartAnnotationPosition) {
                        selectionOverlayView(
                            selection: SCChartSelection(
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
            .scChartXSelection(enabled: gestureConfiguration.allowsSelection, value: selectionIndexBinding)
            .scChartDomain(domain)
            .scChartIndexedXAxis(labels: points.map(\.plottedXValue), axesStyle: axesStyle)
            .scChartNumericYAxis(axesStyle, format: yAxisFormat)
        }
    }

    private var indexedPoints: [SCIndexedChartPoint] {
        points.enumerated().map { SCIndexedChartPoint(index: $0.offset, point: $0.element) }
    }

    private var selectedPoint: SCIndexedChartPoint? {
        guard let label = selection?.xLabel else { return nil }
        return indexedPoints.first { $0.point.plottedXValue == label }
    }

    private var selectionIndexBinding: Binding<Int?> {
        Binding<Int?>(
            get: { selectedPoint?.index },
            set: { newIndex in
                guard gestureConfiguration.allowsSelection else {
                    selection = nil
                    return
                }
                guard let newIndex, indexedPoints.indices.contains(newIndex) else {
                    selection = nil
                    return
                }
                let point = indexedPoints[newIndex].point
                selection = SCChartSelection(xLabel: point.plottedXValue, value: point.value)
            }
        )
    }

    @ViewBuilder
    private func selectionOverlayView(selection: SCChartSelection) -> some View {
        switch inspectionOverlay {
        case .hidden:
            EmptyView()
        case .pointLabel:
            SCChartAnnotationLabelView(annotation: .valueLabel(selection.value, format: yAxisFormat, anchor: inspectionOverlay.anchor))
        case .automatic, .callout, .inspector, .crosshair(_, true):
            SCChartInspectionCallout(selection: selection, valueFormat: yAxisFormat)
        case .crosshair(_, false):
            EmptyView()
        }
    }
}

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
/// A bar chart wrapper with native bar selection and inspection support.
public struct SCSelectableBarChart: View {
    public let points: [SCChartPoint]
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?
    public let inspectionOverlay: SCChartInspectionOverlay
    public let gestureConfiguration: SCChartGestureConfiguration
    public let yAxisFormat: SCChartNumericValueFormat

    @Binding private var selection: SCChartSelection?

    /// Creates a selectable bar chart bound directly to an optional selection.
    public init(
        points: [SCChartPoint],
        selection: Binding<SCChartSelection?>,
        seriesStyle: SCChartSeriesStyle = .bar(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        inspectionOverlay: SCChartInspectionOverlay = .automatic(),
        gestureConfiguration: SCChartGestureConfiguration = .selectionOnly,
        yAxisFormat: SCChartNumericValueFormat = .automatic
    ) {
        self.points = points
        self._selection = selection
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain ?? .auto(points: points, baseZero: true)
        self.inspectionOverlay = inspectionOverlay
        self.gestureConfiguration = gestureConfiguration
        self.yAxisFormat = yAxisFormat
    }

    /// Creates a selectable bar chart bound to the shared selection-state helper.
    public init(
        points: [SCChartPoint],
        selectionState: Binding<SCChartSelectionState>,
        seriesStyle: SCChartSeriesStyle = .bar(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        inspectionOverlay: SCChartInspectionOverlay = .automatic(),
        gestureConfiguration: SCChartGestureConfiguration = .selectionOnly,
        yAxisFormat: SCChartNumericValueFormat = .automatic
    ) {
        self.init(
            points: points,
            selection: Binding(
                get: { selectionState.wrappedValue.selection },
                set: { selectionState.wrappedValue = SCChartSelectionState(selection: $0) }
            ),
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            domain: domain,
            inspectionOverlay: inspectionOverlay,
            gestureConfiguration: gestureConfiguration,
            yAxisFormat: yAxisFormat
        )
    }

    public var body: some View {
        SCNativeChartContainer(axesStyle: axesStyle) {
            Chart(indexedPoints) { entry in
                if selectedPoint?.point.id == entry.point.id, inspectionOverlay.showsCrosshair {
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
                    if selectedPoint?.point.id == entry.point.id, inspectionOverlay.isVisible {
                        selectionOverlayView(
                            selection: SCChartSelection(
                                xLabel: entry.point.plottedXValue,
                                value: entry.point.value
                            )
                        )
                    }
                }
            }
            .scChartXSelection(enabled: gestureConfiguration.allowsSelection, value: selectionIndexBinding)
            .scChartDomain(domain)
            .scChartIndexedXAxis(labels: points.map(\.plottedXValue), axesStyle: axesStyle)
            .scChartNumericYAxis(axesStyle, format: yAxisFormat)
        }
    }

    private var indexedPoints: [SCIndexedChartPoint] {
        points.enumerated().map { SCIndexedChartPoint(index: $0.offset, point: $0.element) }
    }

    private var selectedPoint: SCIndexedChartPoint? {
        guard let label = selection?.xLabel else { return nil }
        return indexedPoints.first { $0.point.plottedXValue == label }
    }

    private var selectionIndexBinding: Binding<Int?> {
        Binding<Int?>(
            get: { selectedPoint?.index },
            set: { newIndex in
                guard gestureConfiguration.allowsSelection else {
                    selection = nil
                    return
                }
                guard let newIndex, indexedPoints.indices.contains(newIndex) else {
                    selection = nil
                    return
                }
                let point = indexedPoints[newIndex].point
                selection = SCChartSelection(xLabel: point.plottedXValue, value: point.value)
            }
        )
    }

    @ViewBuilder
    private func selectionOverlayView(selection: SCChartSelection) -> some View {
        switch inspectionOverlay {
        case .hidden:
            EmptyView()
        case .pointLabel:
            SCChartAnnotationLabelView(annotation: .valueLabel(selection.value, format: yAxisFormat, anchor: inspectionOverlay.anchor))
        case .automatic, .callout, .inspector, .crosshair(_, true):
            SCChartInspectionCallout(selection: selection, valueFormat: yAxisFormat)
        case .crosshair(_, false):
            EmptyView()
        }
    }
}

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
/// A scatter chart wrapper with native point selection and inspection support.
public struct SCSelectableScatterChart: View {
    public let points: [SCChartScatterPoint]
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?
    public let inspectionOverlay: SCChartInspectionOverlay
    public let gestureConfiguration: SCChartGestureConfiguration
    public let yAxisFormat: SCChartNumericValueFormat

    @Binding private var selection: SCChartSelection?

    /// Creates a selectable scatter chart bound directly to an optional selection.
    public init(
        points: [SCChartScatterPoint],
        selection: Binding<SCChartSelection?>,
        seriesStyle: SCChartSeriesStyle = .scatter(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        inspectionOverlay: SCChartInspectionOverlay = .automatic(),
        gestureConfiguration: SCChartGestureConfiguration = .selectionOnly,
        yAxisFormat: SCChartNumericValueFormat = .automatic
    ) {
        self.points = points
        self._selection = selection
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain ?? .auto(values: points.map(\.y))
        self.inspectionOverlay = inspectionOverlay
        self.gestureConfiguration = gestureConfiguration
        self.yAxisFormat = yAxisFormat
    }

    /// Creates a selectable scatter chart bound to the shared selection-state helper.
    public init(
        points: [SCChartScatterPoint],
        selectionState: Binding<SCChartSelectionState>,
        seriesStyle: SCChartSeriesStyle = .scatter(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        inspectionOverlay: SCChartInspectionOverlay = .automatic(),
        gestureConfiguration: SCChartGestureConfiguration = .selectionOnly,
        yAxisFormat: SCChartNumericValueFormat = .automatic
    ) {
        self.init(
            points: points,
            selection: Binding(
                get: { selectionState.wrappedValue.selection },
                set: { selectionState.wrappedValue = SCChartSelectionState(selection: $0) }
            ),
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            domain: domain,
            inspectionOverlay: inspectionOverlay,
            gestureConfiguration: gestureConfiguration,
            yAxisFormat: yAxisFormat
        )
    }

    public var body: some View {
        SCNativeChartContainer(axesStyle: axesStyle) {
            Chart(points) { point in
                if selectedPoint?.id == point.id, inspectionOverlay.showsCrosshair {
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
                .symbolSize(max(seriesStyle.markSize, selectedPoint?.id == point.id ? 80 : seriesStyle.markSize))
                .annotation(position: inspectionOverlay.anchor.chartAnnotationPosition) {
                    if selectedPoint?.id == point.id, inspectionOverlay.isVisible {
                        selectionOverlayView(
                            selection: SCChartSelection(
                                xLabel: point.label ?? point.x.formatted(.number.precision(.fractionLength(2))),
                                value: point.y
                            )
                        )
                    }
                }
            }
            .scChartXSelection(enabled: gestureConfiguration.allowsSelection, value: selectionXBinding)
            .scChartDomain(domain)
            .scChartAxes(axesStyle)
        }
    }

    private var selectedPoint: SCChartScatterPoint? {
        guard let label = selection?.xLabel else { return nil }
        return points.first {
            ($0.label ?? $0.x.formatted(.number.precision(.fractionLength(2)))) == label
        }
    }

    private var selectionXBinding: Binding<Double?> {
        Binding<Double?>(
            get: { selectedPoint?.x },
            set: { newX in
                guard gestureConfiguration.allowsSelection else {
                    selection = nil
                    return
                }
                guard let newX else {
                    selection = nil
                    return
                }
                guard let point = points.first(where: { $0.x == newX }) else {
                    selection = nil
                    return
                }
                selection = SCChartSelection(
                    xLabel: point.label ?? point.x.formatted(.number.precision(.fractionLength(2))),
                    value: point.y
                )
            }
        )
    }

    @ViewBuilder
    private func selectionOverlayView(selection: SCChartSelection) -> some View {
        switch inspectionOverlay {
        case .hidden:
            EmptyView()
        case .pointLabel:
            SCChartAnnotationLabelView(annotation: .valueLabel(selection.value, format: yAxisFormat, anchor: inspectionOverlay.anchor))
        case .automatic, .callout, .inspector, .crosshair(_, true):
            SCChartInspectionCallout(selection: selection, valueFormat: yAxisFormat)
        case .crosshair(_, false):
            EmptyView()
        }
    }
}

struct SCIndexedChartPoint: Identifiable {
    let index: Int
    let point: SCChartPoint

    var id: String { point.id }
}
