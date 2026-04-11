//
//  SCScrollableCharts.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Charts
import SwiftUI

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
public struct SCScrollableLineChart: View {
    public let points: [SCChartPoint]
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?
    public let referenceLines: [SCChartReferenceLine]
    public let scrollBehavior: SCChartScrollBehavior
    public let gestureConfiguration: SCChartGestureConfiguration
    public let yAxisFormat: SCChartNumericValueFormat

    @Binding private var viewport: SCChartViewport

    public init(
        points: [SCChartPoint],
        viewport: Binding<SCChartViewport>,
        scrollBehavior: SCChartScrollBehavior = .continuous(.points(6)),
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
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain ?? .auto(points: points, baseZero: false)
        self.referenceLines = referenceLines
        self.gestureConfiguration = gestureConfiguration
        self.yAxisFormat = yAxisFormat
    }

    public init(
        points: [SCChartPoint],
        viewport: Binding<SCChartViewport>,
        visibleDomain: SCChartVisibleDomain = .points(6),
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
                visibleDomain: scrollBehavior.visibleDomain,
                position: scrollPositionBinding
            )
            .scChartDomain(domain)
            .scChartIndexedXAxis(labels: points.map(\.plottedXValue), axesStyle: axesStyle)
            .scChartNumericYAxis(axesStyle, format: yAxisFormat)
        }
    }

    private var indexedPoints: [SCIndexedScrollablePoint] {
        points.enumerated().map { SCIndexedScrollablePoint(index: $0.offset, point: $0.element) }
    }

    private var effectiveVisibleLength: Double {
        max(viewport.length, scrollBehavior.visibleDomain.length)
    }

    private var scrollPositionBinding: Binding<Double> {
        Binding<Double>(
            get: { viewport.lowerBound },
            set: { newLowerBound in
                guard gestureConfiguration.allowsScrolling else { return }
                viewport = SCChartViewport.starting(at: newLowerBound, length: effectiveVisibleLength)
            }
        )
    }

    public var visibleDomain: SCChartVisibleDomain {
        scrollBehavior.visibleDomain
    }
}

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
public struct SCScrollableTimeSeriesChart: View {
    public let points: [SCChartTimePoint]
    public let scrollBehavior: SCChartScrollBehavior
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?
    public let referenceLines: [SCChartReferenceLine]
    public let xAxisFormat: SCChartDateValueFormat
    public let gestureConfiguration: SCChartGestureConfiguration
    public let yAxisFormat: SCChartNumericValueFormat

    @Binding private var scrollPosition: Date

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
        self._scrollPosition = scrollPosition
        self.scrollBehavior = scrollBehavior
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain ?? .auto(values: points.map(\.value), baseZero: false)
        self.referenceLines = referenceLines
        self.xAxisFormat = xAxisFormat
        self.gestureConfiguration = gestureConfiguration
        self.yAxisFormat = yAxisFormat
    }

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
                visibleDomain: scrollBehavior.visibleDomain,
                position: $scrollPosition
            )
            .scChartDomain(domain)
            .scChartDateXAxis(axesStyle, format: xAxisFormat)
            .scChartNumericYAxis(axesStyle, format: yAxisFormat)
        }
    }

    public var visibleDomain: SCChartVisibleDomain {
        scrollBehavior.visibleDomain
    }
}

private struct SCIndexedScrollablePoint: Identifiable {
    let index: Int
    let point: SCChartPoint

    var id: String { point.id }
}
