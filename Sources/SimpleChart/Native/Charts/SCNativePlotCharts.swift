//
//  SCNativePlotCharts.swift
//
//
//  Created by Codex on 2026-04-10.
//

import Charts
import SwiftUI

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
/// A vectorized line-plot wrapper for numeric x/y point series.
public struct SCNativeLinePlotChart: View {
    public let points: [SCChartPlotPoint]
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?

    /// Creates a line plot from prebuilt numeric plot points.
    public init(
        points: [SCChartPlotPoint],
        seriesStyle: SCChartSeriesStyle = .line(),
        axesStyle: SCChartAxesStyle = .minimal,
        domain: SCChartDomain? = nil
    ) {
        self.points = points
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain ?? .auto(values: points.map(\.y))
    }

    /// Creates a line plot from floating-point `(x, y)` tuples.
    public init<T: BinaryFloatingPoint, U: BinaryFloatingPoint>(
        points: [(T, U)],
        seriesName: String? = nil,
        seriesStyle: SCChartSeriesStyle = .line(),
        axesStyle: SCChartAxesStyle = .minimal,
        domain: SCChartDomain? = nil
    ) {
        let resolvedPoints = SCChartPlotPoint.make(points: points, seriesName: seriesName)
        self.init(points: resolvedPoints, seriesStyle: seriesStyle, axesStyle: axesStyle, domain: domain)
    }

    public var body: some View {
        SCNativeChartContainer(axesStyle: axesStyle) {
            Chart {
                linePlotContent(points: points)
            }
            .scChartDomain(domain)
            .scChartAxes(axesStyle)
        }
    }

    @ChartContentBuilder
    private func linePlotContent(points: [SCChartPlotPoint]) -> some ChartContent {
        if points.contains(where: { $0.seriesName != nil && !($0.seriesName?.isEmpty ?? true) }) {
            LinePlot(
                points,
                x: .value("X", \SCChartPlotPoint.x),
                y: .value("Y", \SCChartPlotPoint.y),
                series: .value("Series", \SCChartPlotPoint.seriesNameToken)
            )
                .lineStyle(StrokeStyle(lineWidth: seriesStyle.strokeWidth))
                .interpolationMethod(seriesStyle.chartInterpolationMethod)
        } else {
            LinePlot(
                points,
                x: .value("X", \SCChartPlotPoint.x),
                y: .value("Y", \SCChartPlotPoint.y)
            )
                .foregroundStyle(seriesStyle.foregroundGradient)
                .lineStyle(StrokeStyle(lineWidth: seriesStyle.strokeWidth))
                .interpolationMethod(seriesStyle.chartInterpolationMethod)
        }
    }
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
/// A vectorized area-plot wrapper for numeric x/y point series.
public struct SCNativeAreaPlotChart: View {
    public let points: [SCChartPlotPoint]
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?
    public let stacking: SCChartPlotStacking

    /// Creates an area plot from prebuilt numeric plot points.
    public init(
        points: [SCChartPlotPoint],
        seriesStyle: SCChartSeriesStyle = .area(),
        axesStyle: SCChartAxesStyle = .minimal,
        domain: SCChartDomain? = nil,
        stacking: SCChartPlotStacking = .standard
    ) {
        self.points = points
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain ?? .auto(values: points.map(\.y))
        self.stacking = stacking
    }

    public var body: some View {
        SCNativeChartContainer(axesStyle: axesStyle) {
            Chart {
                if points.contains(where: { $0.seriesName != nil && !($0.seriesName?.isEmpty ?? true) }) {
                    AreaPlot(
                        points,
                        x: .value("X", \SCChartPlotPoint.x),
                        y: .value("Y", \SCChartPlotPoint.y),
                        series: .value("Series", \SCChartPlotPoint.seriesNameToken),
                        stacking: stacking.markStackingMethod
                    )
                        .interpolationMethod(seriesStyle.chartInterpolationMethod)
                } else {
                    AreaPlot(
                        points,
                        x: .value("X", \SCChartPlotPoint.x),
                        y: .value("Y", \SCChartPlotPoint.y),
                        stacking: stacking.markStackingMethod
                    )
                        .foregroundStyle(seriesStyle.foregroundGradient)
                        .interpolationMethod(seriesStyle.chartInterpolationMethod)
                }
            }
            .scChartDomain(domain)
            .scChartAxes(axesStyle)
        }
    }
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
/// A vectorized bar-plot wrapper for point, span, or range plot input.
public struct SCNativeBarPlotChart: View {
    public let points: [SCChartPlotPoint]
    public let spans: [SCChartPlotSpan]
    public let ranges: [SCChartPlotRange]
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?
    public let width: SCChartPlotDimension
    public let height: SCChartPlotDimension
    public let stacking: SCChartPlotStacking

    /// Creates a bar plot from point-based plot input.
    public init(
        points: [SCChartPlotPoint],
        seriesStyle: SCChartSeriesStyle = .bar(),
        axesStyle: SCChartAxesStyle = .minimal,
        domain: SCChartDomain? = nil,
        width: SCChartPlotDimension = .automatic,
        height: SCChartPlotDimension = .automatic,
        stacking: SCChartPlotStacking = .standard
    ) {
        self.points = points
        self.spans = []
        self.ranges = []
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain ?? .auto(values: points.map(\.y), baseZero: true)
        self.width = width
        self.height = height
        self.stacking = stacking
    }

    /// Creates a bar plot from span-based plot input.
    public init(
        spans: [SCChartPlotSpan],
        seriesStyle: SCChartSeriesStyle = .bar(),
        axesStyle: SCChartAxesStyle = .minimal,
        domain: SCChartDomain? = nil,
        height: SCChartPlotDimension = .automatic
    ) {
        self.points = []
        self.spans = spans
        self.ranges = []
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain ?? .auto(values: spans.map(\.y), baseZero: true)
        self.width = .automatic
        self.height = height
        self.stacking = .standard
    }

    /// Creates a bar plot from range-based plot input.
    public init(
        ranges: [SCChartPlotRange],
        seriesStyle: SCChartSeriesStyle = .bar(),
        axesStyle: SCChartAxesStyle = .minimal,
        domain: SCChartDomain? = nil,
        width: SCChartPlotDimension = .automatic
    ) {
        self.points = []
        self.spans = []
        self.ranges = ranges
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain ?? .auto(
            values: ranges.flatMap { [$0.yStart, $0.yEnd] },
            baseZero: true
        )
        self.width = width
        self.height = .automatic
        self.stacking = .standard
    }

    public var body: some View {
        SCNativeChartContainer(axesStyle: axesStyle) {
            Chart {
                if !points.isEmpty {
                    barPlotContent(points: points)
                } else if !spans.isEmpty {
                    BarPlot(
                        spans,
                        xStart: .value("Start X", \SCChartPlotSpan.xStart),
                        xEnd: .value("End X", \SCChartPlotSpan.xEnd),
                        y: .value("Y", \SCChartPlotSpan.y),
                        height: height.markDimensions()
                    )
                        .foregroundStyle(seriesStyle.foregroundGradient)
                } else {
                    BarPlot(
                        ranges,
                        x: .value("X", \SCChartPlotRange.x),
                        yStart: .value("Start Y", \SCChartPlotRange.yStart),
                        yEnd: .value("End Y", \SCChartPlotRange.yEnd),
                        width: width.markDimensions()
                    )
                        .foregroundStyle(seriesStyle.foregroundGradient)
                }
            }
            .scChartDomain(domain)
            .scChartAxes(axesStyle)
        }
    }

    @ChartContentBuilder
    private func barPlotContent(points: [SCChartPlotPoint]) -> some ChartContent {
        BarPlot(
            points,
            x: .value("X", \SCChartPlotPoint.x),
            y: .value("Y", \SCChartPlotPoint.y),
            width: width.markDimensions(),
            height: height.markDimensions(),
            stacking: stacking.markStackingMethod
        )
        .foregroundStyle(seriesStyle.foregroundGradient)
    }
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
/// A vectorized point-plot wrapper for numeric x/y point series.
public struct SCNativePointPlotChart: View {
    public let points: [SCChartPlotPoint]
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?

    /// Creates a point plot from prebuilt numeric plot points.
    public init(
        points: [SCChartPlotPoint],
        seriesStyle: SCChartSeriesStyle = .scatter(),
        axesStyle: SCChartAxesStyle = .minimal,
        domain: SCChartDomain? = nil
    ) {
        self.points = points
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain ?? .auto(values: points.map(\.y))
    }

    public var body: some View {
        SCNativeChartContainer(axesStyle: axesStyle) {
            Chart {
                PointPlot(
                    points,
                    x: .value("X", \SCChartPlotPoint.x),
                    y: .value("Y", \SCChartPlotPoint.y)
                )
                    .foregroundStyle(seriesStyle.foregroundGradient)
                    .symbolSize(seriesStyle.markSize)
            }
            .scChartDomain(domain)
            .scChartAxes(axesStyle)
        }
    }
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
/// A vectorized rectangle-plot wrapper for explicit numeric rectangles.
public struct SCNativeRectanglePlotChart: View {
    public let rectangles: [SCChartPlotRectangle]
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?
    public let width: SCChartPlotDimension
    public let height: SCChartPlotDimension

    /// Creates a rectangle plot from prebuilt plot rectangles.
    public init(
        rectangles: [SCChartPlotRectangle],
        seriesStyle: SCChartSeriesStyle = .bar(),
        axesStyle: SCChartAxesStyle = .minimal,
        domain: SCChartDomain? = nil,
        width: SCChartPlotDimension = .automatic,
        height: SCChartPlotDimension = .automatic
    ) {
        self.rectangles = rectangles
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain ?? .auto(values: rectangles.flatMap { [$0.yStart, $0.yEnd] })
        self.width = width
        self.height = height
    }

    public var body: some View {
        SCNativeChartContainer(axesStyle: axesStyle) {
            Chart {
                RectanglePlot(
                    rectangles,
                    xStart: .value("Start X", \SCChartPlotRectangle.xStart),
                    xEnd: .value("End X", \SCChartPlotRectangle.xEnd),
                    yStart: .value("Start Y", \SCChartPlotRectangle.yStart),
                    yEnd: .value("End Y", \SCChartPlotRectangle.yEnd)
                )
                .foregroundStyle(seriesStyle.foregroundGradient)
            }
            .scChartDomain(domain)
            .scChartAxes(axesStyle)
        }
    }
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
/// A function-based line-plot wrapper that samples a scalar function over x.
public struct SCNativeFunctionLinePlotChart: View {
    public let xTitle: String
    public let yTitle: String
    public let domain: ClosedRange<Double>?
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let function: @Sendable (Double) -> Double

    /// Creates a function line plot from axis titles and a scalar function.
    public init(
        xTitle: String,
        yTitle: String,
        domain: ClosedRange<Double>? = nil,
        seriesStyle: SCChartSeriesStyle = .line(),
        axesStyle: SCChartAxesStyle = .minimal,
        function: @escaping @Sendable (Double) -> Double
    ) {
        self.xTitle = xTitle
        self.yTitle = yTitle
        self.domain = domain
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.function = function
    }

    public var body: some View {
        SCNativeChartContainer(axesStyle: axesStyle) {
            Chart {
                LinePlot(x: xTitle, y: yTitle, domain: domain, function: function)
                    .foregroundStyle(seriesStyle.foregroundGradient)
                    .lineStyle(StrokeStyle(lineWidth: seriesStyle.strokeWidth))
                    .interpolationMethod(seriesStyle.chartInterpolationMethod)
            }
            .scChartAxes(axesStyle)
        }
    }
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
/// A function-based line-plot wrapper for parametric curves.
public struct SCNativeParametricLinePlotChart: View {
    public let xTitle: String
    public let yTitle: String
    public let parameterTitle: String
    public let parameterDomain: ClosedRange<Double>
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let function: @Sendable (Double) -> (x: Double, y: Double)

    /// Creates a parametric line plot from axis titles, parameter domain, and a curve function.
    public init(
        xTitle: String,
        yTitle: String,
        parameterTitle: String,
        parameterDomain: ClosedRange<Double>,
        seriesStyle: SCChartSeriesStyle = .line(),
        axesStyle: SCChartAxesStyle = .minimal,
        function: @escaping @Sendable (Double) -> (x: Double, y: Double)
    ) {
        self.xTitle = xTitle
        self.yTitle = yTitle
        self.parameterTitle = parameterTitle
        self.parameterDomain = parameterDomain
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.function = function
    }

    public var body: some View {
        SCNativeChartContainer(axesStyle: axesStyle) {
            Chart {
                LinePlot(
                    x: xTitle,
                    y: yTitle,
                    t: parameterTitle,
                    domain: parameterDomain,
                    function: function
                )
                .foregroundStyle(seriesStyle.foregroundGradient)
                .lineStyle(StrokeStyle(lineWidth: seriesStyle.strokeWidth))
                .interpolationMethod(seriesStyle.chartInterpolationMethod)
            }
            .scChartAxes(axesStyle)
        }
    }
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
/// A function-based area-plot wrapper for single-value or band-value functions.
public struct SCNativeFunctionAreaPlotChart: View {
    public let xTitle: String
    public let yTitle: String
    public let yStartTitle: String?
    public let yEndTitle: String?
    public let domain: ClosedRange<Double>?
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let singleFunction: (@Sendable (Double) -> Double)?
    public let bandFunction: (@Sendable (Double) -> (yStart: Double, yEnd: Double))?

    /// Creates a function area plot from a scalar function sampled over x.
    public init(
        xTitle: String,
        yTitle: String,
        domain: ClosedRange<Double>? = nil,
        seriesStyle: SCChartSeriesStyle = .area(),
        axesStyle: SCChartAxesStyle = .minimal,
        function: @escaping @Sendable (Double) -> Double
    ) {
        self.xTitle = xTitle
        self.yTitle = yTitle
        self.yStartTitle = nil
        self.yEndTitle = nil
        self.domain = domain
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.singleFunction = function
        self.bandFunction = nil
    }

    /// Creates a function area plot from a band function sampled over x.
    public init(
        xTitle: String,
        yStartTitle: String,
        yEndTitle: String,
        domain: ClosedRange<Double>? = nil,
        seriesStyle: SCChartSeriesStyle = .area(),
        axesStyle: SCChartAxesStyle = .minimal,
        function: @escaping @Sendable (Double) -> (yStart: Double, yEnd: Double)
    ) {
        self.xTitle = xTitle
        self.yTitle = yEndTitle
        self.yStartTitle = yStartTitle
        self.yEndTitle = yEndTitle
        self.domain = domain
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.singleFunction = nil
        self.bandFunction = function
    }

    public var body: some View {
        SCNativeChartContainer(axesStyle: axesStyle) {
            Chart {
                if let singleFunction {
                    AreaPlot(x: xTitle, y: yTitle, domain: domain, function: singleFunction)
                        .foregroundStyle(seriesStyle.foregroundGradient)
                        .interpolationMethod(seriesStyle.chartInterpolationMethod)
                } else if let bandFunction, let yStartTitle, let yEndTitle {
                    AreaPlot(
                        x: xTitle,
                        yStart: yStartTitle,
                        yEnd: yEndTitle,
                        domain: domain,
                        function: bandFunction
                    )
                    .foregroundStyle(seriesStyle.foregroundGradient)
                    .interpolationMethod(seriesStyle.chartInterpolationMethod)
                }
            }
            .scChartAxes(axesStyle)
        }
    }
}
