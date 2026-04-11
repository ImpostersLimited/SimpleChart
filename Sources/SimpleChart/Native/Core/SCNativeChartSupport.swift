//
//  SCNativeChartSupport.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Charts
import Spatial
import SwiftUI

extension SCChartPoint {
    var plottedXValue: String {
        xLabel ?? id
    }
}

extension SCChartRangePoint {
    var plottedXValue: String {
        xLabel ?? id
    }
}

extension SCHistogramBin {
    var plottedXValue: Double {
        (lowerBound + upperBound) / 2
    }
}

extension SCChartPlotPoint {
    var seriesNameToken: String {
        guard let seriesName, !seriesName.isEmpty else { return "Series" }
        return seriesName
    }
}

extension SCChartPlotSpan {
    var seriesNameToken: String {
        guard let seriesName, !seriesName.isEmpty else { return "Series" }
        return seriesName
    }

    var xStartCGFloat: CGFloat { CGFloat(xStart) }
    var xEndCGFloat: CGFloat { CGFloat(xEnd) }
}

extension SCChartPlotRange {
    var seriesNameToken: String {
        guard let seriesName, !seriesName.isEmpty else { return "Series" }
        return seriesName
    }
}

extension SCChartPlotRectangle {
    var seriesNameToken: String {
        guard let seriesName, !seriesName.isEmpty else { return "Series" }
        return seriesName
    }

    var xStartCGFloat: CGFloat { CGFloat(xStart) }
    var xEndCGFloat: CGFloat { CGFloat(xEnd) }
    var yStartCGFloat: CGFloat { CGFloat(yStart) }
    var yEndCGFloat: CGFloat { CGFloat(yEnd) }
}

extension SCChartAnnotationAnchor {
    var chartAnnotationPosition: AnnotationPosition {
        switch self {
        case .top, .topLeading, .topTrailing:
            return .top
        case .bottom, .bottomLeading, .bottomTrailing:
            return .bottom
        case .overlay:
            return .overlay
        }
    }
}

extension SCChartAxisPosition {
    var yAxisPosition: AxisMarkPosition {
        switch self {
        case .trailing:
            return .trailing
        case .leading, .automatic, .top, .bottom:
            return .leading
        }
    }
}

extension SCChartLegendVisibility {
    var swiftUIVisibility: Visibility {
        switch self {
        case .automatic:
            return .automatic
        case .visible:
            return .visible
        case .hidden:
            return .hidden
        }
    }
}

extension SCChartLegendPosition {
    @available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
    var chartLegendPosition: AnnotationPosition? {
        switch self {
        case .automatic:
            return nil
        case .top:
            return .top
        case .bottom:
            return .bottom
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        case .overlay:
            return .overlay
        }
    }
}

extension SCChartSeriesStyle {
    var primaryColor: Color {
        colors.first ?? .primary
    }

    var foregroundGradient: LinearGradient {
        LinearGradient(
            colors: colors.isEmpty ? [.primary] : colors,
            startPoint: gradientStart,
            endPoint: gradientEnd
        )
    }

    var chartInterpolationMethod: InterpolationMethod {
        switch interpolation {
        case .linear:
            return .linear
        case .monotone:
            return .monotone
        case .catmullRom:
            return .catmullRom
        }
    }
}

extension SCChartReferenceLine {
    var strokeStyle: StrokeStyle {
        StrokeStyle(lineWidth: lineWidth, dash: dash)
    }
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension SCChartPlotStacking {
    var markStackingMethod: MarkStackingMethod {
        switch self {
        case .standard:
            return .standard
        case .normalized:
            return .normalized
        case .center:
            return .center
        case .unstacked:
            return .unstacked
        }
    }
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension SCChartPlotDimension {
    var markDimension: MarkDimension {
        switch self {
        case .automatic:
            return .automatic
        case let .fixed(value):
            return .fixed(value)
        case let .ratio(value):
            return .ratio(value)
        case let .inset(value):
            return .inset(value)
        }
    }

    func markDimensions<DataElement>() -> MarkDimensions<DataElement> {
        switch self {
        case .automatic:
            return .automatic
        case let .fixed(value):
            return .fixed(value)
        case let .ratio(value):
            return .ratio(value)
        case let .inset(value):
            return .inset(value)
        }
    }
}

@available(iOS 26.0, macOS 26.0, visionOS 26.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension SCChart3DPoseStyle {
    var chart3DPose: Chart3DPose {
        switch self {
        case .default:
            return .default
        case .front:
            return .front
        case .back:
            return .back
        case .top:
            return .top
        case .bottom:
            return .bottom
        case .left:
            return .left
        case .right:
            return .right
        case let .custom(azimuthDegrees, inclinationDegrees):
            return Chart3DPose(
                azimuth: .degrees(azimuthDegrees),
                inclination: .degrees(inclinationDegrees)
            )
        }
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }

    func cycled(to count: Int) -> [Element] {
        guard !isEmpty, count > 0 else { return [] }
        return (0..<count).map { self[$0 % self.count] }
    }
}

extension View {
    @ViewBuilder
    func scChartDomain(_ domain: SCChartDomain?) -> some View {
        if let domain {
            chartYScale(domain: domain.yScaleRange)
        } else {
            self
        }
    }

    @ViewBuilder
    func scChartYScale(
        _ scale: SCChartScale,
        fallbackDomain: SCChartDomain? = nil
    ) -> some View {
        scChartDomain(scale.yDomain ?? fallbackDomain)
    }

    @ViewBuilder
    func scChartXScale(_ scale: SCChartScale) -> some View {
        if #available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *),
           let visibleDomain = scale.xVisibleDomain {
            chartXVisibleDomain(length: visibleDomain.length)
        } else {
            self
        }
    }

    @available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
    @ViewBuilder
    func scChartXSelection<Value: Plottable>(
        enabled: Bool,
        value: Binding<Value?>
    ) -> some View {
        if enabled {
            chartXSelection(value: value)
        } else {
            self
        }
    }

    @available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
    @ViewBuilder
    func scChartAngleSelection<Value: Plottable>(
        enabled: Bool,
        value: Binding<Value?>
    ) -> some View {
        if enabled {
            chartAngleSelection(value: value)
        } else {
            self
        }
    }

    @available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
    @ViewBuilder
    func scChartScrollableX(
        enabled: Bool,
        visibleDomain: SCChartVisibleDomain,
        position: Binding<Double>
    ) -> some View {
        if enabled {
            chartScrollableAxes(.horizontal)
                .chartXVisibleDomain(length: visibleDomain.length)
                .chartScrollPosition(x: position)
        } else {
            self
        }
    }

    @available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
    @ViewBuilder
    func scChartScrollableX(
        enabled: Bool,
        visibleDomain: SCChartVisibleDomain,
        position: Binding<Date>
    ) -> some View {
        if enabled {
            chartScrollableAxes(.horizontal)
                .chartXVisibleDomain(length: visibleDomain.length)
                .chartScrollPosition(x: position)
        } else {
            self
        }
    }

    @ViewBuilder
    func scChartAxes(_ axesStyle: SCChartAxesStyle) -> some View {
        scChartAxes(xAxis: axesStyle.xAxis, yAxis: axesStyle.yAxis)
    }

    @ViewBuilder
    func scChartAxes(xAxis: SCChartAxis, yAxis: SCChartAxis) -> some View {
        scChartXAxis(xAxis)
            .scChartYAxis(yAxis)
    }

    @ViewBuilder
    private func scChartXAxis(_ axis: SCChartAxis) -> some View {
        if axis.isVisible || axis.marks.showGrid {
            chartXAxis {
                scAxisMarks(axis)
            }
        } else {
            chartXAxis(.hidden)
        }
    }

    @ViewBuilder
    private func scChartYAxis(_ axis: SCChartAxis) -> some View {
        if axis.isVisible || axis.marks.showGrid || axis.marks.showLabels {
            chartYAxis {
                scAxisMarks(axis, position: axis.position.yAxisPosition)
            }
        } else {
            chartYAxis(.hidden)
        }
    }

    @ViewBuilder
    func scChartLegend(_ legend: SCChartLegend) -> some View {
        if #available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *),
           let position = legend.position.chartLegendPosition {
            chartLegend(legend.visibility.swiftUIVisibility)
                .chartLegend(position: position, alignment: legend.alignment, spacing: legend.spacing)
        } else {
            chartLegend(legend.visibility.swiftUIVisibility)
        }
    }

    @ViewBuilder
    func scChartPlotStyle(_ plotStyle: SCChartPlotStyle) -> some View {
        chartPlotStyle { plotArea in
            let baseShape = RoundedRectangle(cornerRadius: plotStyle.cornerRadius, style: .continuous)
            let styled = plotArea
                .padding(plotStyle.padding)
                .background(plotStyle.backgroundColor.opacity(plotStyle.backgroundOpacity))
                .clipShape(baseShape)
                .overlay {
                    if let borderColor = plotStyle.borderColor, plotStyle.borderWidth > 0 {
                        baseShape
                            .stroke(borderColor, lineWidth: plotStyle.borderWidth)
                    }
                }

            if plotStyle.clipContent {
                styled.clipped()
            } else {
                styled
            }
        }
    }

    @ViewBuilder
    func scChartForegroundStyleScale(_ scale: SCChartForegroundStyleScale?) -> some View {
        if let scale {
            chartForegroundStyleScale(
                domain: scale.domain,
                range: scale.range.cycled(to: scale.domain.count)
            )
        } else {
            self
        }
    }

    @ViewBuilder
    func scChartNumericYAxis(
        _ axesStyle: SCChartAxesStyle,
        format: SCChartNumericValueFormat = .automatic
    ) -> some View {
        if axesStyle.showYAxis || axesStyle.showGrid || axesStyle.showYAxisLabels {
            chartYAxis {
                AxisMarks(position: .leading, values: .automatic(desiredCount: axesStyle.preferredIntervalCount + 1)) { value in
                    if axesStyle.showGrid {
                        AxisGridLine(stroke: StrokeStyle(lineWidth: axesStyle.intervalLineWidth))
                            .foregroundStyle(axesStyle.intervalColor)
                    }
                    if axesStyle.showYAxis {
                        AxisTick(stroke: StrokeStyle(lineWidth: axesStyle.intervalLineWidth))
                            .foregroundStyle(axesStyle.intervalColor)
                    }
                    if axesStyle.showYAxisLabels {
                        AxisValueLabel {
                            if let numeric = value.as(Double.self) {
                                Text(format.string(from: numeric))
                                    .foregroundStyle(axesStyle.yAxisFigureColor)
                            } else if let numeric = value.as(Int.self) {
                                Text(format.string(from: Double(numeric)))
                                    .foregroundStyle(axesStyle.yAxisFigureColor)
                            }
                        }
                    }
                }
            }
        } else {
            chartYAxis(.hidden)
        }
    }

    @ViewBuilder
    func scChartIndexedXAxis(
        labels: [String],
        axesStyle: SCChartAxesStyle
    ) -> some View {
        if axesStyle.showXAxis || axesStyle.showGrid {
            chartXAxis {
                AxisMarks(values: indexedAxisValues(count: labels.count, desiredIntervals: axesStyle.preferredIntervalCount)) { value in
                    if axesStyle.showGrid {
                        AxisGridLine(stroke: StrokeStyle(lineWidth: axesStyle.intervalLineWidth))
                            .foregroundStyle(axesStyle.intervalColor)
                    }
                    if axesStyle.showXAxis {
                        AxisTick(stroke: StrokeStyle(lineWidth: axesStyle.intervalLineWidth))
                            .foregroundStyle(axesStyle.intervalColor)
                        AxisValueLabel {
                            if let index = value.as(Int.self), labels.indices.contains(index) {
                                Text(labels[index])
                                    .foregroundStyle(axesStyle.xLegendColor)
                            } else if let numeric = value.as(Double.self) {
                                let index = Int(numeric.rounded())
                                if labels.indices.contains(index) {
                                    Text(labels[index])
                                        .foregroundStyle(axesStyle.xLegendColor)
                                }
                            }
                        }
                    }
                }
            }
        } else {
            chartXAxis(.hidden)
        }
    }

    @ViewBuilder
    func scChartDateXAxis(
        _ axesStyle: SCChartAxesStyle,
        format: SCChartDateValueFormat = .automatic
    ) -> some View {
        if axesStyle.showXAxis || axesStyle.showGrid {
            chartXAxis {
                AxisMarks(values: .automatic(desiredCount: axesStyle.preferredIntervalCount + 1)) { value in
                    if axesStyle.showGrid {
                        AxisGridLine(stroke: StrokeStyle(lineWidth: axesStyle.intervalLineWidth))
                            .foregroundStyle(axesStyle.intervalColor)
                    }
                    if axesStyle.showXAxis {
                        AxisTick(stroke: StrokeStyle(lineWidth: axesStyle.intervalLineWidth))
                            .foregroundStyle(axesStyle.intervalColor)
                        AxisValueLabel {
                            if let date = value.as(Date.self) {
                                Text(format.string(from: date))
                                    .foregroundStyle(axesStyle.xLegendColor)
                            }
                        }
                    }
                }
            }
        } else {
            chartXAxis(.hidden)
        }
    }
}

private extension View {
    @AxisContentBuilder
    func scAxisMarks(
        _ axis: SCChartAxis,
        position: AxisMarkPosition? = nil
    ) -> some AxisContent {
        let axisPosition = position ?? .automatic
        switch axis.marks.valueSource {
        case let .automatic(desiredCount):
            AxisMarks(
                preset: .automatic,
                position: axisPosition,
                values: .automatic(desiredCount: (desiredCount ?? axis.marks.desiredCount) + 1)
            ) { _ in
                if axis.marks.showGrid {
                    AxisGridLine(stroke: StrokeStyle(lineWidth: axis.marks.lineWidth))
                        .foregroundStyle(axis.marks.lineColor)
                }
                if axis.isVisible && axis.marks.showTicks {
                    AxisTick(stroke: StrokeStyle(lineWidth: axis.marks.lineWidth))
                        .foregroundStyle(axis.marks.lineColor)
                }
                if axis.isVisible && axis.marks.showLabels {
                    AxisValueLabel()
                        .foregroundStyle(axis.marks.labelColor)
                }
            }
        case let .integers(values):
            AxisMarks(preset: .automatic, position: axisPosition, values: values) { _ in
                if axis.marks.showGrid {
                    AxisGridLine(stroke: StrokeStyle(lineWidth: axis.marks.lineWidth))
                        .foregroundStyle(axis.marks.lineColor)
                }
                if axis.isVisible && axis.marks.showTicks {
                    AxisTick(stroke: StrokeStyle(lineWidth: axis.marks.lineWidth))
                        .foregroundStyle(axis.marks.lineColor)
                }
                if axis.isVisible && axis.marks.showLabels {
                    AxisValueLabel()
                        .foregroundStyle(axis.marks.labelColor)
                }
            }
        case let .doubles(values):
            AxisMarks(preset: .automatic, position: axisPosition, values: values) { _ in
                if axis.marks.showGrid {
                    AxisGridLine(stroke: StrokeStyle(lineWidth: axis.marks.lineWidth))
                        .foregroundStyle(axis.marks.lineColor)
                }
                if axis.isVisible && axis.marks.showTicks {
                    AxisTick(stroke: StrokeStyle(lineWidth: axis.marks.lineWidth))
                        .foregroundStyle(axis.marks.lineColor)
                }
                if axis.isVisible && axis.marks.showLabels {
                    AxisValueLabel()
                        .foregroundStyle(axis.marks.labelColor)
                }
            }
        case let .strings(values):
            AxisMarks(preset: .automatic, position: axisPosition, values: values) { _ in
                if axis.marks.showGrid {
                    AxisGridLine(stroke: StrokeStyle(lineWidth: axis.marks.lineWidth))
                        .foregroundStyle(axis.marks.lineColor)
                }
                if axis.isVisible && axis.marks.showTicks {
                    AxisTick(stroke: StrokeStyle(lineWidth: axis.marks.lineWidth))
                        .foregroundStyle(axis.marks.lineColor)
                }
                if axis.isVisible && axis.marks.showLabels {
                    AxisValueLabel()
                        .foregroundStyle(axis.marks.labelColor)
                }
            }
        case let .dates(values):
            AxisMarks(preset: .automatic, position: axisPosition, values: values) { _ in
                if axis.marks.showGrid {
                    AxisGridLine(stroke: StrokeStyle(lineWidth: axis.marks.lineWidth))
                        .foregroundStyle(axis.marks.lineColor)
                }
                if axis.isVisible && axis.marks.showTicks {
                    AxisTick(stroke: StrokeStyle(lineWidth: axis.marks.lineWidth))
                        .foregroundStyle(axis.marks.lineColor)
                }
                if axis.isVisible && axis.marks.showLabels {
                    AxisValueLabel()
                        .foregroundStyle(axis.marks.labelColor)
                }
            }
        }
    }
}

private func indexedAxisValues(count: Int, desiredIntervals: Int) -> [Int] {
    guard count > 0 else { return [] }
    if count == 1 { return [0] }

    let step = max(1, Int(ceil(Double(count - 1) / Double(max(desiredIntervals, 1)))))
    let values = stride(from: 0, to: count, by: step).map { $0 }
    if values.last == count - 1 {
        return values
    }
    return values + [count - 1]
}
