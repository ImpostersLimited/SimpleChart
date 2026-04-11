//
//  SCSelectableTimeSeriesChart.swift
//
//
//  Created by Codex on 2026-04-10.
//

import Charts
import SwiftUI

/// An availability-gated time-series line wrapper with native point selection and inspection support.
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
public struct SCSelectableTimeSeriesChart: View {
    public let points: [SCChartTimePoint]
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?
    public let referenceLines: [SCChartReferenceLine]
    public let inspectionOverlay: SCChartInspectionOverlay
    public let gestureConfiguration: SCChartGestureConfiguration
    public let xAxisFormat: SCChartDateValueFormat
    public let yAxisFormat: SCChartNumericValueFormat

    @Binding private var selection: SCChartSelection?

    /// Creates a selectable time-series chart bound directly to an optional selection.
    public init(
        points: [SCChartTimePoint],
        selection: Binding<SCChartSelection?>,
        seriesStyle: SCChartSeriesStyle = .line(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        referenceLines: [SCChartReferenceLine] = [],
        inspectionOverlay: SCChartInspectionOverlay = .automatic(),
        gestureConfiguration: SCChartGestureConfiguration = .selectionOnly,
        xAxisFormat: SCChartDateValueFormat = .monthDay,
        yAxisFormat: SCChartNumericValueFormat = .automatic
    ) {
        self.points = points.sorted { $0.date < $1.date }
        self._selection = selection
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain ?? .auto(values: points.map(\.value), baseZero: false)
        self.referenceLines = referenceLines
        self.inspectionOverlay = inspectionOverlay
        self.gestureConfiguration = gestureConfiguration
        self.xAxisFormat = xAxisFormat
        self.yAxisFormat = yAxisFormat
    }

    /// Creates a selectable time-series chart bound to the shared selection-state helper.
    public init(
        points: [SCChartTimePoint],
        selectionState: Binding<SCChartSelectionState>,
        seriesStyle: SCChartSeriesStyle = .line(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        referenceLines: [SCChartReferenceLine] = [],
        inspectionOverlay: SCChartInspectionOverlay = .automatic(),
        gestureConfiguration: SCChartGestureConfiguration = .selectionOnly,
        xAxisFormat: SCChartDateValueFormat = .monthDay,
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
            xAxisFormat: xAxisFormat,
            yAxisFormat: yAxisFormat
        )
    }

    public var body: some View {
        SCNativeChartContainer(axesStyle: axesStyle) {
            Chart(points) { point in
                if selectedPoint?.id == point.id, inspectionOverlay.showsCrosshair {
                    RuleMark(x: .value("Date", point.date))
                        .foregroundStyle(seriesStyle.primaryColor.opacity(0.45))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 4]))

                    RuleMark(y: .value("Value", point.value))
                        .foregroundStyle(seriesStyle.primaryColor.opacity(0.25))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 4]))
                }

                if seriesStyle.showArea {
                    AreaMark(
                        x: .value("Date", point.date),
                        y: .value("Value", point.value)
                    )
                    .foregroundStyle(seriesStyle.foregroundGradient)
                    .interpolationMethod(seriesStyle.chartInterpolationMethod)
                }

                LineMark(
                    x: .value("Date", point.date),
                    y: .value("Value", point.value)
                )
                .foregroundStyle(seriesStyle.foregroundGradient)
                .lineStyle(StrokeStyle(lineWidth: seriesStyle.strokeWidth))
                .interpolationMethod(seriesStyle.chartInterpolationMethod)

                if selectedPoint?.id == point.id, inspectionOverlay.isVisible {
                    PointMark(
                        x: .value("Date", point.date),
                        y: .value("Value", point.value)
                    )
                    .foregroundStyle(seriesStyle.primaryColor)
                    .symbolSize(max(seriesStyle.markSize, 60))
                    .annotation(position: inspectionOverlay.anchor.chartAnnotationPosition) {
                        selectionOverlayView(
                            selection: SCChartSelection(
                                xLabel: xAxisFormat.string(from: point.date),
                                value: point.value
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
            .scChartXSelection(enabled: gestureConfiguration.allowsSelection, value: selectionDateBinding)
            .scChartDomain(domain)
            .scChartDateXAxis(axesStyle, format: xAxisFormat)
            .scChartNumericYAxis(axesStyle, format: yAxisFormat)
        }
    }

    private var selectedPoint: SCChartTimePoint? {
        guard let label = selection?.xLabel else { return nil }
        return points.first { xAxisFormat.string(from: $0.date) == label }
    }

    private var selectionDateBinding: Binding<Date?> {
        Binding<Date?>(
            get: { selectedPoint?.date },
            set: { newDate in
                guard gestureConfiguration.allowsSelection else {
                    selection = nil
                    return
                }
                guard let newDate else {
                    selection = nil
                    return
                }
                guard let point = nearestPoint(to: newDate) else {
                    selection = nil
                    return
                }
                selection = SCChartSelection(
                    xLabel: xAxisFormat.string(from: point.date),
                    value: point.value
                )
            }
        )
    }

    private func nearestPoint(to date: Date) -> SCChartTimePoint? {
        points.min { lhs, rhs in
            abs(lhs.date.timeIntervalSince(date)) < abs(rhs.date.timeIntervalSince(date))
        }
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
