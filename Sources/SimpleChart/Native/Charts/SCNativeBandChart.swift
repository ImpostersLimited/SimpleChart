//
//  SCNativeBandChart.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Charts
import SwiftUI

public struct SCNativeBandChart: View {
    public let categories: [String]
    public let bands: [SCChartBand]
    public let axesStyle: SCChartAxesStyle
    public let xAxis: SCChartAxis?
    public let yAxis: SCChartAxis?
    public let legend: SCChartLegend
    public let plotStyle: SCChartPlotStyle
    public let domain: SCChartDomain?

    public init(
        categories: [String],
        bands: [SCChartBand],
        axesStyle: SCChartAxesStyle = .standard(),
        xAxis: SCChartAxis? = nil,
        yAxis: SCChartAxis? = nil,
        legend: SCChartLegend = .hidden,
        plotStyle: SCChartPlotStyle = .standard,
        domain: SCChartDomain? = nil,
        baseZero: Bool = false,
        paddingRatio: Double = 0.03
    ) {
        self.categories = categories
        self.bands = bands
        self.axesStyle = axesStyle
        self.xAxis = xAxis
        self.yAxis = yAxis
        self.legend = legend
        self.plotStyle = plotStyle
        self.domain = domain ?? .auto(
            values: bands.flatMap { [$0.lower, $0.upper] },
            baseZero: baseZero,
            paddingRatio: paddingRatio
        )
    }

    public init<T: BinaryFloatingPoint>(
        categories: [String],
        bands: [(String, T, T)],
        color: Color = .accentColor,
        opacity: Double = 0.15,
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
            categories: categories,
            bands: SCChartBand.make(bands: bands, color: color, opacity: opacity),
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

    public init<T: BinaryInteger>(
        categories: [String],
        bands: [(String, T, T)],
        color: Color = .accentColor,
        opacity: Double = 0.15,
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
            categories: categories,
            bands: SCChartBand.make(bands: bands, color: color, opacity: opacity),
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
            Chart {
                ForEach(categories, id: \.self) { category in
                    ForEach(bands) { band in
                        BarMark(
                            x: .value("Category", category),
                            yStart: .value("Lower", band.lower),
                            yEnd: .value("Upper", band.upper),
                            width: .ratio(0.96)
                        )
                        .foregroundStyle(band.color.opacity(band.opacity))
                    }
                }

                ForEach(bands) { band in
                    if let annotation = band.annotation ?? defaultAnnotation(for: band) {
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
            .scChartDomain(domain)
            .scChartAxes(xAxis: xAxis ?? axesStyle.xAxis, yAxis: yAxis ?? axesStyle.yAxis)
        }
    }

    private func defaultAnnotation(for band: SCChartBand) -> SCChartAnnotation? {
        guard !band.title.isEmpty else { return nil }
        return .lineLabel(band.title, color: band.color)
    }
}
