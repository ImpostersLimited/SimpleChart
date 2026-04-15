//
//  SCScrollableCharts.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Charts
import SwiftUI

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
/// A categorical line chart wrapper with scrollable x-domain support.
public struct SCScrollableLineChart: View {
    public let points: [SCChartPoint]
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?
    public let referenceLines: [SCChartReferenceLine]
    public let scrollBehavior: SCChartScrollBehavior
    /// The zoom policy applied to the visible x-domain window.
    public let zoomBehavior: SCChartZoomBehavior
    public let gestureConfiguration: SCChartGestureConfiguration
    public let yAxisFormat: SCChartNumericValueFormat

    @Binding private var viewport: SCChartViewport
    @State private var lastMagnification: CGFloat = 1

    /// Creates a scrollable line chart bound to an explicit viewport value.
    ///
    /// Bind a full ``SCChartViewport`` when the surrounding view needs to read or update the current indexed window programmatically.
    public init(
        points: [SCChartPoint],
        viewport: Binding<SCChartViewport>,
        scrollBehavior: SCChartScrollBehavior = .continuous(.points(6)),
        zoomBehavior: SCChartZoomBehavior = .standard,
        seriesStyle: SCChartSeriesStyle = .line(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        referenceLines: [SCChartReferenceLine] = [],
        gestureConfiguration: SCChartGestureConfiguration = .scrollOnly,
        yAxisFormat: SCChartNumericValueFormat = .automatic
    ) {
        self.points = points
        self._viewport = viewport
        self.scrollBehavior = scrollBehavior
        self.zoomBehavior = zoomBehavior
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain ?? .auto(points: points, baseZero: false)
        self.referenceLines = referenceLines
        self.gestureConfiguration = gestureConfiguration
        self.yAxisFormat = yAxisFormat
    }

    /// Creates a scrollable line chart from a visible-domain helper instead of a full scroll behavior.
    ///
    /// Use this initializer when the chart should still expose viewport state externally but the initial window is easier to describe as a visible-domain helper.
    public init(
        points: [SCChartPoint],
        viewport: Binding<SCChartViewport>,
        visibleDomain: SCChartVisibleDomain = .points(6),
        zoomBehavior: SCChartZoomBehavior = .standard,
        seriesStyle: SCChartSeriesStyle = .line(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        referenceLines: [SCChartReferenceLine] = [],
        gestureConfiguration: SCChartGestureConfiguration = .scrollOnly,
        yAxisFormat: SCChartNumericValueFormat = .automatic
    ) {
        self.init(
            points: points,
            viewport: viewport,
            scrollBehavior: .continuous(visibleDomain),
            zoomBehavior: zoomBehavior,
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            domain: domain,
            referenceLines: referenceLines,
            gestureConfiguration: gestureConfiguration,
            yAxisFormat: yAxisFormat
        )
    }

    public var body: some View {
        SCNativeChartContainer(axesStyle: axesStyle) {
            Chart(indexedPoints) { entry in
                if seriesStyle.showArea {
                    AreaMark(
                        x: .value("Index", Double(entry.index)),
                        y: .value("Value", entry.point.value)
                    )
                    .foregroundStyle(seriesStyle.foregroundGradient)
                    .interpolationMethod(seriesStyle.chartInterpolationMethod)
                }

                LineMark(
                    x: .value("Index", Double(entry.index)),
                    y: .value("Value", entry.point.value)
                )
                .foregroundStyle(seriesStyle.foregroundGradient)
                .lineStyle(StrokeStyle(lineWidth: seriesStyle.strokeWidth))
                .interpolationMethod(seriesStyle.chartInterpolationMethod)

                ForEach(referenceLines) { referenceLine in
                    RuleMark(y: .value(referenceLine.title, referenceLine.value))
                        .foregroundStyle(referenceLine.color)
                        .lineStyle(referenceLine.strokeStyle)
                }
            }
            .scChartScrollableX(
                enabled: gestureConfiguration.allowsScrolling,
                visibleDomain: renderedVisibleDomain,
                position: scrollPositionBinding
            )
            .scChartDomain(domain)
            .scChartIndexedXAxis(labels: points.map(\.plottedXValue), axesStyle: axesStyle)
            .scChartNumericYAxis(axesStyle, format: yAxisFormat)
        }
        .simultaneousGesture(zoomGesture)
    }

    private var indexedPoints: [SCIndexedScrollablePoint] {
        points.enumerated().map { SCIndexedScrollablePoint(index: $0.offset, point: $0.element) }
    }

    private var bounds: ClosedRange<Double> {
        0...max(Double(max(points.count, 1)), 0.0001)
    }

    private var effectiveViewport: SCChartViewport {
        SCChartNavigationCoordinator.clampedViewport(
            viewport,
            zoomBehavior: zoomBehavior,
            bounds: bounds
        )
    }

    private var scrollPositionBinding: Binding<Double> {
        Binding<Double>(
            get: { effectiveViewport.lowerBound },
            set: { newLowerBound in
                guard gestureConfiguration.allowsScrolling else { return }
                viewport = SCChartNavigationCoordinator.scrollViewport(
                    effectiveViewport,
                    to: newLowerBound,
                    zoomBehavior: zoomBehavior,
                    bounds: bounds
                )
            }
        )
    }

    /// The visible-domain window currently configured on the wrapper.
    ///
    /// This reflects the wrapper's public state rather than the internally clamped render window used while applying gesture updates.
    public var visibleDomain: SCChartVisibleDomain {
        SCChartVisibleDomain(length: viewport.length)
    }

    private var renderedVisibleDomain: SCChartVisibleDomain {
        SCChartVisibleDomain(length: effectiveViewport.length)
    }

    private var zoomGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                guard gestureConfiguration.allowsZooming, zoomBehavior.isEnabled else { return }
                let delta = Double(value / lastMagnification)
                lastMagnification = value
                viewport = SCChartNavigationCoordinator.zoomViewport(
                    effectiveViewport,
                    magnification: delta,
                    zoomBehavior: zoomBehavior,
                    bounds: bounds
                )
            }
            .onEnded { _ in
                lastMagnification = 1
            }
    }
}

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
/// A time-series line chart wrapper with scrollable date-domain support.
public struct SCScrollableTimeSeriesChart: View {
    public let points: [SCChartTimePoint]
    public let scrollBehavior: SCChartScrollBehavior
    /// The zoom policy applied to the visible date-domain window.
    public let zoomBehavior: SCChartZoomBehavior
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?
    public let referenceLines: [SCChartReferenceLine]
    public let xAxisFormat: SCChartDateValueFormat
    public let gestureConfiguration: SCChartGestureConfiguration
    public let yAxisFormat: SCChartNumericValueFormat

    private let navigationSource: SCTimeNavigationSource
    @State private var lastMagnification: CGFloat = 1

    /// Creates a scrollable time-series chart bound to an explicit date scroll position.
    ///
    /// This compatibility initializer keeps the original scroll-position model and disables zoom-specific state so existing call sites keep their behavior.
    public init(
        points: [SCChartTimePoint],
        scrollPosition: Binding<Date>,
        scrollBehavior: SCChartScrollBehavior = .timeWindow(seconds: 60 * 60 * 24 * 7),
        seriesStyle: SCChartSeriesStyle = .line(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        referenceLines: [SCChartReferenceLine] = [],
        xAxisFormat: SCChartDateValueFormat = .monthDay,
        gestureConfiguration: SCChartGestureConfiguration = .scrollOnly,
        yAxisFormat: SCChartNumericValueFormat = .automatic
    ) {
        self.points = points.sorted { $0.date < $1.date }
        self.navigationSource = .scrollPosition(scrollPosition)
        self.scrollBehavior = scrollBehavior
        self.zoomBehavior = .disabled
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain ?? .auto(values: points.map(\.value), baseZero: false)
        self.referenceLines = referenceLines
        self.xAxisFormat = xAxisFormat
        self.gestureConfiguration = gestureConfiguration
        self.yAxisFormat = yAxisFormat
    }

    /// Creates a scrollable time-series chart from a visible-domain helper instead of a full scroll behavior.
    ///
    /// Use this when a date-based chart still uses the legacy scroll-position binding but the initial window is easier to describe through ``SCChartVisibleDomain``.
    public init(
        points: [SCChartTimePoint],
        scrollPosition: Binding<Date>,
        visibleDomain: SCChartVisibleDomain = .seconds(60 * 60 * 24 * 7),
        seriesStyle: SCChartSeriesStyle = .line(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        referenceLines: [SCChartReferenceLine] = [],
        xAxisFormat: SCChartDateValueFormat = .monthDay,
        gestureConfiguration: SCChartGestureConfiguration = .scrollOnly,
        yAxisFormat: SCChartNumericValueFormat = .automatic
    ) {
        self.init(
            points: points,
            scrollPosition: scrollPosition,
            scrollBehavior: .continuous(visibleDomain),
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            domain: domain,
            referenceLines: referenceLines,
            xAxisFormat: xAxisFormat,
            gestureConfiguration: gestureConfiguration,
            yAxisFormat: yAxisFormat
        )
    }

    /// Creates a scrollable and zoomable time-series chart bound to an explicit viewport value.
    ///
    /// Bind a full ``SCChartTimeViewport`` when the chart needs programmatic zoom or when multiple controls should coordinate the same visible date range.
    public init(
        points: [SCChartTimePoint],
        viewport: Binding<SCChartTimeViewport>,
        scrollBehavior: SCChartScrollBehavior = .timeWindow(seconds: 60 * 60 * 24 * 7),
        zoomBehavior: SCChartZoomBehavior = .standard,
        seriesStyle: SCChartSeriesStyle = .line(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        referenceLines: [SCChartReferenceLine] = [],
        xAxisFormat: SCChartDateValueFormat = .monthDay,
        gestureConfiguration: SCChartGestureConfiguration = .scrollOnly,
        yAxisFormat: SCChartNumericValueFormat = .automatic
    ) {
        self.points = points.sorted { $0.date < $1.date }
        self.navigationSource = .viewport(viewport)
        self.scrollBehavior = scrollBehavior
        self.zoomBehavior = zoomBehavior
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain ?? .auto(values: points.map(\.value), baseZero: false)
        self.referenceLines = referenceLines
        self.xAxisFormat = xAxisFormat
        self.gestureConfiguration = gestureConfiguration
        self.yAxisFormat = yAxisFormat
    }

    public var body: some View {
        SCNativeChartContainer(axesStyle: axesStyle) {
            Chart(points) { point in
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

                ForEach(referenceLines) { referenceLine in
                    RuleMark(y: .value(referenceLine.title, referenceLine.value))
                        .foregroundStyle(referenceLine.color)
                        .lineStyle(referenceLine.strokeStyle)
                }
            }
            .scChartScrollableX(
                enabled: gestureConfiguration.allowsScrolling,
                visibleDomain: renderedVisibleDomain,
                position: scrollPositionBinding
            )
            .scChartDomain(domain)
            .scChartDateXAxis(axesStyle, format: xAxisFormat)
            .scChartNumericYAxis(axesStyle, format: yAxisFormat)
        }
        .simultaneousGesture(zoomGesture)
    }

    /// The visible-domain window currently configured on the wrapper.
    ///
    /// This reflects the wrapper's public viewport state rather than the internally clamped render window used while processing scroll and zoom updates.
    public var visibleDomain: SCChartVisibleDomain {
        SCChartVisibleDomain(length: currentViewport.length)
    }

    private var renderedVisibleDomain: SCChartVisibleDomain {
        SCChartVisibleDomain(length: effectiveViewport.length)
    }

    private var bounds: ClosedRange<Date> {
        let fallback = currentViewport.startDate
        let lowerBound = points.first?.date ?? fallback
        let upperBound = points.last?.date ?? fallback.addingTimeInterval(max(scrollBehavior.visibleDomain.length, 0.0001))
        return lowerBound...max(lowerBound, upperBound)
    }

    private var currentViewport: SCChartTimeViewport {
        switch navigationSource {
        case let .scrollPosition(scrollPosition):
            return SCChartTimeViewport.starting(
                at: scrollPosition.wrappedValue,
                duration: scrollBehavior.visibleDomain.length
            )
        case let .viewport(viewport):
            return viewport.wrappedValue
        }
    }

    private var effectiveZoomBehavior: SCChartZoomBehavior {
        switch navigationSource {
        case .scrollPosition:
            return .disabled
        case .viewport:
            return zoomBehavior
        }
    }

    private var effectiveViewport: SCChartTimeViewport {
        SCChartNavigationCoordinator.clampedViewport(
            currentViewport,
            zoomBehavior: effectiveZoomBehavior,
            bounds: bounds
        )
    }

    private var scrollPositionBinding: Binding<Date> {
        Binding<Date>(
            get: { effectiveViewport.startDate },
            set: { newStartDate in
                guard gestureConfiguration.allowsScrolling else { return }
                assign(
                    SCChartNavigationCoordinator.scrollViewport(
                        effectiveViewport,
                        to: newStartDate,
                        zoomBehavior: effectiveZoomBehavior,
                        bounds: bounds
                    )
                )
            }
        )
    }

    private var zoomGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                guard gestureConfiguration.allowsZooming, effectiveZoomBehavior.isEnabled else { return }
                let delta = Double(value / lastMagnification)
                lastMagnification = value
                assign(
                    SCChartNavigationCoordinator.zoomViewport(
                        effectiveViewport,
                        magnification: delta,
                        zoomBehavior: effectiveZoomBehavior,
                        bounds: bounds
                    )
                )
            }
            .onEnded { _ in
                lastMagnification = 1
            }
    }

    private func assign(_ viewport: SCChartTimeViewport) {
        switch navigationSource {
        case let .scrollPosition(scrollPosition):
            scrollPosition.wrappedValue = viewport.startDate
        case let .viewport(binding):
            binding.wrappedValue = viewport
        }
    }
}

private struct SCIndexedScrollablePoint: Identifiable {
    let index: Int
    let point: SCChartPoint

    var id: String { point.id }
}

private enum SCTimeNavigationSource {
    case scrollPosition(Binding<Date>)
    case viewport(Binding<SCChartTimeViewport>)
}
