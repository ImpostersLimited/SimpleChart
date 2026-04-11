//
//  SCNativeRectangleChart.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Charts
import SwiftUI

public struct SCNativeRectangleChart: View {
    public let rectangles: [SCChartRectangle]
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let xAxis: SCChartAxis?
    public let yAxis: SCChartAxis?
    public let legend: SCChartLegend
    public let plotStyle: SCChartPlotStyle
    public let domain: SCChartDomain?

    public init(
        rectangles: [SCChartRectangle],
        seriesStyle: SCChartSeriesStyle = .bar(),
        axesStyle: SCChartAxesStyle = .standard(),
        xAxis: SCChartAxis? = nil,
        yAxis: SCChartAxis? = nil,
        legend: SCChartLegend = .hidden,
        plotStyle: SCChartPlotStyle = .standard,
        domain: SCChartDomain? = nil,
        baseZero: Bool = false,
        paddingRatio: Double = 0.03
    ) {
        self.rectangles = rectangles
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.xAxis = xAxis
        self.yAxis = yAxis
        self.legend = legend
        self.plotStyle = plotStyle
        self.domain = domain ?? .auto(
            values: rectangles.flatMap { [$0.yStart, $0.yEnd] },
            baseZero: baseZero,
            paddingRatio: paddingRatio
        )
    }

    public init<T: BinaryFloatingPoint, U: BinaryFloatingPoint>(
        rectangles: [(T, T, U, U)],
        colors: [Color] = [],
        seriesStyle: SCChartSeriesStyle = .bar(),
        axesStyle: SCChartAxesStyle = .standard(),
        xAxis: SCChartAxis? = nil,
        yAxis: SCChartAxis? = nil,
        legend: SCChartLegend = .hidden,
        plotStyle: SCChartPlotStyle = .standard,
        domain: SCChartDomain? = nil,
        baseZero: Bool = false,
        paddingRatio: Double = 0.03
    ) {
        self.init(
            rectangles: SCChartRectangle.make(rectangles: rectangles, colors: colors),
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            xAxis: xAxis,
            yAxis: yAxis,
            legend: legend,
            plotStyle: plotStyle,
            domain: domain,
            baseZero: baseZero,
            paddingRatio: paddingRatio
        )
    }

    public init<T: BinaryInteger, U: BinaryInteger>(
        rectangles: [(T, T, U, U)],
        colors: [Color] = [],
        seriesStyle: SCChartSeriesStyle = .bar(),
        axesStyle: SCChartAxesStyle = .standard(),
        xAxis: SCChartAxis? = nil,
        yAxis: SCChartAxis? = nil,
        legend: SCChartLegend = .hidden,
        plotStyle: SCChartPlotStyle = .standard,
        domain: SCChartDomain? = nil,
        baseZero: Bool = false,
        paddingRatio: Double = 0.03
    ) {
        self.init(
            rectangles: SCChartRectangle.make(rectangles: rectangles, colors: colors),
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            xAxis: xAxis,
            yAxis: yAxis,
            legend: legend,
            plotStyle: plotStyle,
            domain: domain,
            baseZero: baseZero,
            paddingRatio: paddingRatio
        )
    }

    public var body: some View {
        SCNativeChartContainer(
            axesStyle: axesStyle,
            xAxis: xAxis,
            yAxis: yAxis,
            legend: legend,
            plotStyle: plotStyle
        ) {
            Chart(rectangles) { rectangle in
                RectangleMark(
                    xStart: .value("Start X", rectangle.xStart),
                    xEnd: .value("End X", rectangle.xEnd),
                    yStart: .value("Start Y", rectangle.yStart),
                    yEnd: .value("End Y", rectangle.yEnd)
                )
                .foregroundStyle(rectangle.color ?? seriesStyle.primaryColor)
                .annotation(
                    position: rectangle.annotation?.anchor.chartAnnotationPosition ?? .top,
                    alignment: rectangle.annotation?.alignment ?? .center
                ) {
                    if let annotation = rectangle.annotation {
                        SCChartAnnotationLabelView(annotation: annotation)
                    }
                }
            }
            .scChartDomain(domain)
            .scChartAxes(xAxis: xAxis ?? axesStyle.xAxis, yAxis: yAxis ?? axesStyle.yAxis)
        }
    }
}
