//
//  SCSelectableSectorCharts.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Charts
import SwiftUI

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
public struct SCSelectableSectorChart: View {
    public let segments: [SCChartSectorSegment]
    public let palette: [Color]
    public let inspectionOverlay: SCChartInspectionOverlay
    public let gestureConfiguration: SCChartGestureConfiguration

    @Binding private var selection: SCChartSelection?

    public init(
        segments: [SCChartSectorSegment],
        selection: Binding<SCChartSelection?>,
        palette: [Color] = [.accentColor, .blue, .orange, .green, .pink, .purple],
        inspectionOverlay: SCChartInspectionOverlay = .automatic(),
        gestureConfiguration: SCChartGestureConfiguration = .selectionOnly
    ) {
        self.segments = segments
        self._selection = selection
        self.palette = palette
        self.inspectionOverlay = inspectionOverlay
        self.gestureConfiguration = gestureConfiguration
    }

    public init(
        segments: [SCChartSectorSegment],
        selectionState: Binding<SCChartSelectionState>,
        palette: [Color] = [.accentColor, .blue, .orange, .green, .pink, .purple],
        inspectionOverlay: SCChartInspectionOverlay = .automatic(),
        gestureConfiguration: SCChartGestureConfiguration = .selectionOnly
    ) {
        self.init(
            segments: segments,
            selection: Binding(
                get: { selectionState.wrappedValue.selection },
                set: { selectionState.wrappedValue = SCChartSelectionState(selection: $0) }
            ),
            palette: palette,
            inspectionOverlay: inspectionOverlay,
            gestureConfiguration: gestureConfiguration
        )
    }

    public init<T: BinaryFloatingPoint>(
        segments: [(String, T)],
        selection: Binding<SCChartSelection?>,
        colors: [Color] = [],
        palette: [Color] = [.accentColor, .blue, .orange, .green, .pink, .purple],
        inspectionOverlay: SCChartInspectionOverlay = .automatic(),
        gestureConfiguration: SCChartGestureConfiguration = .selectionOnly
    ) {
        self.init(
            segments: SCChartSectorSegment.make(segments: segments, colors: colors),
            selection: selection,
            palette: palette,
            inspectionOverlay: inspectionOverlay,
            gestureConfiguration: gestureConfiguration
        )
    }

    public init<T: BinaryInteger>(
        segments: [(String, T)],
        selection: Binding<SCChartSelection?>,
        colors: [Color] = [],
        palette: [Color] = [.accentColor, .blue, .orange, .green, .pink, .purple],
        inspectionOverlay: SCChartInspectionOverlay = .automatic(),
        gestureConfiguration: SCChartGestureConfiguration = .selectionOnly
    ) {
        self.init(
            segments: SCChartSectorSegment.make(segments: segments, colors: colors),
            selection: selection,
            palette: palette,
            inspectionOverlay: inspectionOverlay,
            gestureConfiguration: gestureConfiguration
        )
    }

    public var body: some View {
        Chart(Array(segments.enumerated()), id: \.element.id) { index, segment in
            SectorMark(
                angle: .value("Value", segment.value),
                innerRadius: .ratio(0)
            )
            .foregroundStyle(segment.color ?? palette[index % max(palette.count, 1)])
            .opacity(selectedSegment?.id == nil || selectedSegment?.id == segment.id ? 1 : 0.55)
            .annotation(position: inspectionOverlay.anchor.chartAnnotationPosition) {
                if selectedSegment?.id == segment.id, inspectionOverlay.isVisible {
                    selectionOverlayView(
                        selection: SCChartSelection(
                            xLabel: segment.title,
                            value: segment.value
                        )
                    )
                }
            }
        }
        .scChartAngleSelection(enabled: gestureConfiguration.allowsSelection, value: selectedAngleBinding)
    }

    private var selectedSegment: SCChartSectorSegment? {
        guard let label = selection?.xLabel else { return nil }
        return segments.first(where: { $0.title == label })
    }

    private var cumulativeRanges: [(segment: SCChartSectorSegment, lower: Double, upper: Double)] {
        var running = 0.0
        return segments.map { segment in
            let lower = running
            running += max(segment.value, 0)
            return (segment, lower, running)
        }
    }

    private var selectedAngleBinding: Binding<Double?> {
        Binding<Double?>(
            get: {
                guard let selectedSegment else { return nil }
                guard let range = cumulativeRanges.first(where: { $0.segment.id == selectedSegment.id }) else {
                    return nil
                }
                return (range.lower + range.upper) / 2
            },
            set: { newValue in
                guard gestureConfiguration.allowsSelection else {
                    selection = nil
                    return
                }
                guard let newValue else {
                    selection = nil
                    return
                }
                guard let range = cumulativeRanges.first(where: { newValue >= $0.lower && newValue <= $0.upper }) else {
                    selection = nil
                    return
                }
                selection = SCChartSelection(xLabel: range.segment.title, value: range.segment.value)
            }
        )
    }

    @ViewBuilder
    private func selectionOverlayView(selection: SCChartSelection) -> some View {
        switch inspectionOverlay {
        case .hidden:
            EmptyView()
        case .pointLabel:
            SCChartAnnotationLabelView(annotation: .valueLabel(selection.value, anchor: inspectionOverlay.anchor))
        case .automatic, .callout, .inspector, .crosshair(_, true):
            SCChartInspectionCallout(selection: selection, valueFormat: .automatic)
        case .crosshair(_, false):
            EmptyView()
        }
    }
}

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
public struct SCSelectableDonutChart: View {
    public let segments: [SCChartSectorSegment]
    public let innerRadiusRatio: Double
    public let palette: [Color]
    public let inspectionOverlay: SCChartInspectionOverlay
    public let gestureConfiguration: SCChartGestureConfiguration

    @Binding private var selection: SCChartSelection?

    public init(
        segments: [SCChartSectorSegment],
        selection: Binding<SCChartSelection?>,
        innerRadiusRatio: Double = 0.6,
        palette: [Color] = [.accentColor, .blue, .orange, .green, .pink, .purple],
        inspectionOverlay: SCChartInspectionOverlay = .automatic(),
        gestureConfiguration: SCChartGestureConfiguration = .selectionOnly
    ) {
        self.segments = segments
        self._selection = selection
        self.innerRadiusRatio = innerRadiusRatio
        self.palette = palette
        self.inspectionOverlay = inspectionOverlay
        self.gestureConfiguration = gestureConfiguration
    }

    public init(
        segments: [SCChartSectorSegment],
        selectionState: Binding<SCChartSelectionState>,
        innerRadiusRatio: Double = 0.6,
        palette: [Color] = [.accentColor, .blue, .orange, .green, .pink, .purple],
        inspectionOverlay: SCChartInspectionOverlay = .automatic(),
        gestureConfiguration: SCChartGestureConfiguration = .selectionOnly
    ) {
        self.init(
            segments: segments,
            selection: Binding(
                get: { selectionState.wrappedValue.selection },
                set: { selectionState.wrappedValue = SCChartSelectionState(selection: $0) }
            ),
            innerRadiusRatio: innerRadiusRatio,
            palette: palette,
            inspectionOverlay: inspectionOverlay,
            gestureConfiguration: gestureConfiguration
        )
    }

    public init<T: BinaryFloatingPoint>(
        segments: [(String, T)],
        selection: Binding<SCChartSelection?>,
        innerRadiusRatio: Double = 0.6,
        colors: [Color] = [],
        palette: [Color] = [.accentColor, .blue, .orange, .green, .pink, .purple],
        inspectionOverlay: SCChartInspectionOverlay = .automatic(),
        gestureConfiguration: SCChartGestureConfiguration = .selectionOnly
    ) {
        self.init(
            segments: SCChartSectorSegment.make(segments: segments, colors: colors),
            selection: selection,
            innerRadiusRatio: innerRadiusRatio,
            palette: palette,
            inspectionOverlay: inspectionOverlay,
            gestureConfiguration: gestureConfiguration
        )
    }

    public init<T: BinaryInteger>(
        segments: [(String, T)],
        selection: Binding<SCChartSelection?>,
        innerRadiusRatio: Double = 0.6,
        colors: [Color] = [],
        palette: [Color] = [.accentColor, .blue, .orange, .green, .pink, .purple],
        inspectionOverlay: SCChartInspectionOverlay = .automatic(),
        gestureConfiguration: SCChartGestureConfiguration = .selectionOnly
    ) {
        self.init(
            segments: SCChartSectorSegment.make(segments: segments, colors: colors),
            selection: selection,
            innerRadiusRatio: innerRadiusRatio,
            palette: palette,
            inspectionOverlay: inspectionOverlay,
            gestureConfiguration: gestureConfiguration
        )
    }

    public var body: some View {
        Chart(Array(segments.enumerated()), id: \.element.id) { index, segment in
            SectorMark(
                angle: .value("Value", segment.value),
                innerRadius: .ratio(innerRadiusRatio)
            )
            .foregroundStyle(segment.color ?? palette[index % max(palette.count, 1)])
            .opacity(selectedSegment?.id == nil || selectedSegment?.id == segment.id ? 1 : 0.55)
            .annotation(position: inspectionOverlay.anchor.chartAnnotationPosition) {
                if selectedSegment?.id == segment.id, inspectionOverlay.isVisible {
                    selectionOverlayView(
                        selection: SCChartSelection(
                            xLabel: segment.title,
                            value: segment.value
                        )
                    )
                }
            }
        }
        .scChartAngleSelection(enabled: gestureConfiguration.allowsSelection, value: selectedAngleBinding)
    }

    private var selectedSegment: SCChartSectorSegment? {
        guard let label = selection?.xLabel else { return nil }
        return segments.first(where: { $0.title == label })
    }

    private var cumulativeRanges: [(segment: SCChartSectorSegment, lower: Double, upper: Double)] {
        var running = 0.0
        return segments.map { segment in
            let lower = running
            running += max(segment.value, 0)
            return (segment, lower, running)
        }
    }

    private var selectedAngleBinding: Binding<Double?> {
        Binding<Double?>(
            get: {
                guard let selectedSegment else { return nil }
                guard let range = cumulativeRanges.first(where: { $0.segment.id == selectedSegment.id }) else {
                    return nil
                }
                return (range.lower + range.upper) / 2
            },
            set: { newValue in
                guard gestureConfiguration.allowsSelection else {
                    selection = nil
                    return
                }
                guard let newValue else {
                    selection = nil
                    return
                }
                guard let range = cumulativeRanges.first(where: { newValue >= $0.lower && newValue <= $0.upper }) else {
                    selection = nil
                    return
                }
                selection = SCChartSelection(xLabel: range.segment.title, value: range.segment.value)
            }
        )
    }

    @ViewBuilder
    private func selectionOverlayView(selection: SCChartSelection) -> some View {
        switch inspectionOverlay {
        case .hidden:
            EmptyView()
        case .pointLabel:
            SCChartAnnotationLabelView(annotation: .valueLabel(selection.value, anchor: inspectionOverlay.anchor))
        case .automatic, .callout, .inspector, .crosshair(_, true):
            SCChartInspectionCallout(selection: selection, valueFormat: .automatic)
        case .crosshair(_, false):
            EmptyView()
        }
    }
}
